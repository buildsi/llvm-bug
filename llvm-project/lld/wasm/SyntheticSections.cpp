//===- SyntheticSections.cpp ----------------------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file contains linker-synthesized sections.
//
//===----------------------------------------------------------------------===//

#include "SyntheticSections.h"

#include "InputChunks.h"
#include "InputElement.h"
#include "OutputSegment.h"
#include "SymbolTable.h"
#include "llvm/Support/Path.h"

using namespace llvm;
using namespace llvm::wasm;

namespace lld {
namespace wasm {

OutStruct out;

namespace {

// Some synthetic sections (e.g. "name" and "linking") have subsections.
// Just like the synthetic sections themselves these need to be created before
// they can be written out (since they are preceded by their length). This
// class is used to create subsections and then write them into the stream
// of the parent section.
class SubSection {
public:
  explicit SubSection(uint32_t type) : type(type) {}

  void writeTo(raw_ostream &to) {
    os.flush();
    writeUleb128(to, type, "subsection type");
    writeUleb128(to, body.size(), "subsection size");
    to.write(body.data(), body.size());
  }

private:
  uint32_t type;
  std::string body;

public:
  raw_string_ostream os{body};
};

} // namespace

void DylinkSection::writeBody() {
  raw_ostream &os = bodyOutputStream;

  {
    SubSection sub(WASM_DYLINK_MEM_INFO);
    writeUleb128(sub.os, memSize, "MemSize");
    writeUleb128(sub.os, memAlign, "MemAlign");
    writeUleb128(sub.os, out.elemSec->numEntries(), "TableSize");
    writeUleb128(sub.os, 0, "TableAlign");
    sub.writeTo(os);
  }

  if (symtab->sharedFiles.size()) {
    SubSection sub(WASM_DYLINK_NEEDED);
    writeUleb128(sub.os, symtab->sharedFiles.size(), "Needed");
    for (auto *so : symtab->sharedFiles)
      writeStr(sub.os, llvm::sys::path::filename(so->getName()), "so name");
    sub.writeTo(os);
  }

  // Under certain circumstances we need to include extra information about the
  // exports we are providing to the dynamic linker.  Currently this is only the
  // case for TLS symbols where the exported value is relative to __tls_base
  // rather than __memory_base.
  std::vector<const Symbol *> exportInfo;
  for (const Symbol *sym : symtab->getSymbols()) {
    if (sym->isExported() && sym->isLive() && sym->isTLS() &&
        isa<DefinedData>(sym)) {
      exportInfo.push_back(sym);
    }
  }

  if (!exportInfo.empty()) {
    SubSection sub(WASM_DYLINK_EXPORT_INFO);
    writeUleb128(sub.os, exportInfo.size(), "num exports");

    for (const Symbol *sym : exportInfo) {
      LLVM_DEBUG(llvm::dbgs() << "export info: " << toString(*sym) << "\n");
      StringRef name = sym->getName();
      if (auto *f = dyn_cast<DefinedFunction>(sym)) {
        if (Optional<StringRef> exportName = f->function->getExportName()) {
          name = *exportName;
        }
      }
      writeStr(sub.os, name, "sym name");
      writeUleb128(sub.os, sym->flags, "sym flags");
    }

    sub.writeTo(os);
  }
}

uint32_t TypeSection::registerType(const WasmSignature &sig) {
  auto pair = typeIndices.insert(std::make_pair(sig, types.size()));
  if (pair.second) {
    LLVM_DEBUG(llvm::dbgs() << "type " << toString(sig) << "\n");
    types.push_back(&sig);
  }
  return pair.first->second;
}

uint32_t TypeSection::lookupType(const WasmSignature &sig) {
  auto it = typeIndices.find(sig);
  if (it == typeIndices.end()) {
    error("type not found: " + toString(sig));
    return 0;
  }
  return it->second;
}

void TypeSection::writeBody() {
  writeUleb128(bodyOutputStream, types.size(), "type count");
  for (const WasmSignature *sig : types)
    writeSig(bodyOutputStream, *sig);
}

uint32_t ImportSection::getNumImports() const {
  assert(isSealed);
  uint32_t numImports = importedSymbols.size() + gotSymbols.size();
  if (config->importMemory)
    ++numImports;
  return numImports;
}

void ImportSection::addGOTEntry(Symbol *sym) {
  assert(!isSealed);
  if (sym->hasGOTIndex())
    return;
  LLVM_DEBUG(dbgs() << "addGOTEntry: " << toString(*sym) << "\n");
  sym->setGOTIndex(numImportedGlobals++);
  gotSymbols.push_back(sym);
}

void ImportSection::addImport(Symbol *sym) {
  assert(!isSealed);
  StringRef module = sym->importModule.getValueOr(defaultModule);
  StringRef name = sym->importName.getValueOr(sym->getName());
  if (auto *f = dyn_cast<FunctionSymbol>(sym)) {
    ImportKey<WasmSignature> key(*(f->getSignature()), module, name);
    auto entry = importedFunctions.try_emplace(key, numImportedFunctions);
    if (entry.second) {
      importedSymbols.emplace_back(sym);
      f->setFunctionIndex(numImportedFunctions++);
    } else {
      f->setFunctionIndex(entry.first->second);
    }
  } else if (auto *g = dyn_cast<GlobalSymbol>(sym)) {
    ImportKey<WasmGlobalType> key(*(g->getGlobalType()), module, name);
    auto entry = importedGlobals.try_emplace(key, numImportedGlobals);
    if (entry.second) {
      importedSymbols.emplace_back(sym);
      g->setGlobalIndex(numImportedGlobals++);
    } else {
      g->setGlobalIndex(entry.first->second);
    }
  } else if (auto *t = dyn_cast<TagSymbol>(sym)) {
    // NB: There's currently only one possible kind of tag, and no
    // `UndefinedTag`, so we don't bother de-duplicating tag imports.
    importedSymbols.emplace_back(sym);
    t->setTagIndex(numImportedTags++);
  } else {
    assert(TableSymbol::classof(sym));
    auto *table = cast<TableSymbol>(sym);
    ImportKey<WasmTableType> key(*(table->getTableType()), module, name);
    auto entry = importedTables.try_emplace(key, numImportedTables);
    if (entry.second) {
      importedSymbols.emplace_back(sym);
      table->setTableNumber(numImportedTables++);
    } else {
      table->setTableNumber(entry.first->second);
    }
  }
}

void ImportSection::writeBody() {
  raw_ostream &os = bodyOutputStream;

  writeUleb128(os, getNumImports(), "import count");

  bool is64 = config->is64.getValueOr(false);

  if (config->importMemory) {
    WasmImport import;
    import.Module = defaultModule;
    import.Field = "memory";
    import.Kind = WASM_EXTERNAL_MEMORY;
    import.Memory.Flags = 0;
    import.Memory.Minimum = out.memorySec->numMemoryPages;
    if (out.memorySec->maxMemoryPages != 0 || config->sharedMemory) {
      import.Memory.Flags |= WASM_LIMITS_FLAG_HAS_MAX;
      import.Memory.Maximum = out.memorySec->maxMemoryPages;
    }
    if (config->sharedMemory)
      import.Memory.Flags |= WASM_LIMITS_FLAG_IS_SHARED;
    if (is64)
      import.Memory.Flags |= WASM_LIMITS_FLAG_IS_64;
    writeImport(os, import);
  }

  for (const Symbol *sym : importedSymbols) {
    WasmImport import;
    import.Field = sym->importName.getValueOr(sym->getName());
    import.Module = sym->importModule.getValueOr(defaultModule);

    if (auto *functionSym = dyn_cast<FunctionSymbol>(sym)) {
      import.Kind = WASM_EXTERNAL_FUNCTION;
      import.SigIndex = out.typeSec->lookupType(*functionSym->signature);
    } else if (auto *globalSym = dyn_cast<GlobalSymbol>(sym)) {
      import.Kind = WASM_EXTERNAL_GLOBAL;
      import.Global = *globalSym->getGlobalType();
    } else if (auto *tagSym = dyn_cast<TagSymbol>(sym)) {
      import.Kind = WASM_EXTERNAL_TAG;
      import.Tag.Attribute = tagSym->getTagType()->Attribute;
      import.Tag.SigIndex = out.typeSec->lookupType(*tagSym->signature);
    } else {
      auto *tableSym = cast<TableSymbol>(sym);
      import.Kind = WASM_EXTERNAL_TABLE;
      import.Table = *tableSym->getTableType();
    }
    writeImport(os, import);
  }

  for (const Symbol *sym : gotSymbols) {
    WasmImport import;
    import.Kind = WASM_EXTERNAL_GLOBAL;
    auto ptrType = is64 ? WASM_TYPE_I64 : WASM_TYPE_I32;
    import.Global = {static_cast<uint8_t>(ptrType), true};
    if (isa<DataSymbol>(sym))
      import.Module = "GOT.mem";
    else
      import.Module = "GOT.func";
    import.Field = sym->getName();
    writeImport(os, import);
  }
}

void FunctionSection::writeBody() {
  raw_ostream &os = bodyOutputStream;

  writeUleb128(os, inputFunctions.size(), "function count");
  for (const InputFunction *func : inputFunctions)
    writeUleb128(os, out.typeSec->lookupType(func->signature), "sig index");
}

void FunctionSection::addFunction(InputFunction *func) {
  if (!func->live)
    return;
  uint32_t functionIndex =
      out.importSec->getNumImportedFunctions() + inputFunctions.size();
  inputFunctions.emplace_back(func);
  func->setFunctionIndex(functionIndex);
}

void TableSection::writeBody() {
  raw_ostream &os = bodyOutputStream;

  writeUleb128(os, inputTables.size(), "table count");
  for (const InputTable *table : inputTables)
    writeTableType(os, table->getType());
}

void TableSection::addTable(InputTable *table) {
  if (!table->live)
    return;
  // Some inputs require that the indirect function table be assigned to table
  // number 0.
  if (config->legacyFunctionTable &&
      isa<DefinedTable>(WasmSym::indirectFunctionTable) &&
      cast<DefinedTable>(WasmSym::indirectFunctionTable)->table == table) {
    if (out.importSec->getNumImportedTables()) {
      // Alack!  Some other input imported a table, meaning that we are unable
      // to assign table number 0 to the indirect function table.
      for (const auto *culprit : out.importSec->importedSymbols) {
        if (isa<UndefinedTable>(culprit)) {
          error("object file not built with 'reference-types' feature "
                "conflicts with import of table " +
                culprit->getName() + " by file " +
                toString(culprit->getFile()));
          return;
        }
      }
      llvm_unreachable("failed to find conflicting table import");
    }
    inputTables.insert(inputTables.begin(), table);
    return;
  }
  inputTables.push_back(table);
}

void TableSection::assignIndexes() {
  uint32_t tableNumber = out.importSec->getNumImportedTables();
  for (InputTable *t : inputTables)
    t->assignIndex(tableNumber++);
}

void MemorySection::writeBody() {
  raw_ostream &os = bodyOutputStream;

  bool hasMax = maxMemoryPages != 0 || config->sharedMemory;
  writeUleb128(os, 1, "memory count");
  unsigned flags = 0;
  if (hasMax)
    flags |= WASM_LIMITS_FLAG_HAS_MAX;
  if (config->sharedMemory)
    flags |= WASM_LIMITS_FLAG_IS_SHARED;
  if (config->is64.getValueOr(false))
    flags |= WASM_LIMITS_FLAG_IS_64;
  writeUleb128(os, flags, "memory limits flags");
  writeUleb128(os, numMemoryPages, "initial pages");
  if (hasMax)
    writeUleb128(os, maxMemoryPages, "max pages");
}

void TagSection::writeBody() {
  raw_ostream &os = bodyOutputStream;

  writeUleb128(os, inputTags.size(), "tag count");
  for (InputTag *t : inputTags) {
    WasmTagType type = t->getType();
    type.SigIndex = out.typeSec->lookupType(t->signature);
    writeTagType(os, type);
  }
}

void TagSection::addTag(InputTag *tag) {
  if (!tag->live)
    return;
  uint32_t tagIndex = out.importSec->getNumImportedTags() + inputTags.size();
  LLVM_DEBUG(dbgs() << "addTag: " << tagIndex << "\n");
  tag->assignIndex(tagIndex);
  inputTags.push_back(tag);
}

void GlobalSection::assignIndexes() {
  uint32_t globalIndex = out.importSec->getNumImportedGlobals();
  for (InputGlobal *g : inputGlobals)
    g->assignIndex(globalIndex++);
  for (Symbol *sym : internalGotSymbols)
    sym->setGOTIndex(globalIndex++);
  isSealed = true;
}

static void ensureIndirectFunctionTable() {
  if (!WasmSym::indirectFunctionTable)
    WasmSym::indirectFunctionTable =
        symtab->resolveIndirectFunctionTable(/*required =*/true);
}

void GlobalSection::addInternalGOTEntry(Symbol *sym) {
  assert(!isSealed);
  if (sym->requiresGOT)
    return;
  LLVM_DEBUG(dbgs() << "addInternalGOTEntry: " << sym->getName() << " "
                    << toString(sym->kind()) << "\n");
  sym->requiresGOT = true;
  if (auto *F = dyn_cast<FunctionSymbol>(sym)) {
    ensureIndirectFunctionTable();
    out.elemSec->addEntry(F);
  }
  internalGotSymbols.push_back(sym);
}

void GlobalSection::generateRelocationCode(raw_ostream &os, bool TLS) const {
  bool is64 = config->is64.getValueOr(false);
  unsigned opcode_ptr_const = is64 ? WASM_OPCODE_I64_CONST
                                   : WASM_OPCODE_I32_CONST;
  unsigned opcode_ptr_add = is64 ? WASM_OPCODE_I64_ADD
                                 : WASM_OPCODE_I32_ADD;

  for (const Symbol *sym : internalGotSymbols) {
    if (TLS != sym->isTLS())
      continue;

    if (auto *d = dyn_cast<DefinedData>(sym)) {
      // Get __memory_base
      writeU8(os, WASM_OPCODE_GLOBAL_GET, "GLOBAL_GET");
      if (sym->isTLS())
        writeUleb128(os, WasmSym::tlsBase->getGlobalIndex(), "__tls_base");
      else
        writeUleb128(os, WasmSym::memoryBase->getGlobalIndex(),
                     "__memory_base");

      // Add the virtual address of the data symbol
      writeU8(os, opcode_ptr_const, "CONST");
      writeSleb128(os, d->getVA(), "offset");
    } else if (auto *f = dyn_cast<FunctionSymbol>(sym)) {
      if (f->isStub)
        continue;
      // Get __table_base
      writeU8(os, WASM_OPCODE_GLOBAL_GET, "GLOBAL_GET");
      writeUleb128(os, WasmSym::tableBase->getGlobalIndex(), "__table_base");

      // Add the table index to __table_base
      writeU8(os, opcode_ptr_const, "CONST");
      writeSleb128(os, f->getTableIndex(), "offset");
    } else {
      assert(isa<UndefinedData>(sym));
      continue;
    }
    writeU8(os, opcode_ptr_add, "ADD");
    writeU8(os, WASM_OPCODE_GLOBAL_SET, "GLOBAL_SET");
    writeUleb128(os, sym->getGOTIndex(), "got_entry");
  }
}

void GlobalSection::writeBody() {
  raw_ostream &os = bodyOutputStream;

  writeUleb128(os, numGlobals(), "global count");
  for (InputGlobal *g : inputGlobals) {
    writeGlobalType(os, g->getType());
    writeInitExpr(os, g->getInitExpr());
  }
  bool is64 = config->is64.getValueOr(false);
  uint8_t itype = is64 ? WASM_TYPE_I64 : WASM_TYPE_I32;
  for (const Symbol *sym : internalGotSymbols) {
    // In the case of dynamic linking, internal GOT entries
    // need to be mutable since they get updated to the correct
    // runtime value during `__wasm_apply_global_relocs`.
    bool mutable_ = config->isPic & !sym->isStub;
    WasmGlobalType type{itype, mutable_};
    WasmInitExpr initExpr;
    if (auto *d = dyn_cast<DefinedData>(sym))
      initExpr = intConst(d->getVA(), is64);
    else if (auto *f = dyn_cast<FunctionSymbol>(sym))
      initExpr = intConst(f->isStub ? 0 : f->getTableIndex(), is64);
    else {
      assert(isa<UndefinedData>(sym));
      initExpr = intConst(0, is64);
    }
    writeGlobalType(os, type);
    writeInitExpr(os, initExpr);
  }
  for (const DefinedData *sym : dataAddressGlobals) {
    WasmGlobalType type{itype, false};
    writeGlobalType(os, type);
    writeInitExpr(os, intConst(sym->getVA(), is64));
  }
}

void GlobalSection::addGlobal(InputGlobal *global) {
  assert(!isSealed);
  if (!global->live)
    return;
  inputGlobals.push_back(global);
}

void ExportSection::writeBody() {
  raw_ostream &os = bodyOutputStream;

  writeUleb128(os, exports.size(), "export count");
  for (const WasmExport &export_ : exports)
    writeExport(os, export_);
}

bool StartSection::isNeeded() const {
  return WasmSym::startFunction != nullptr;
}

void StartSection::writeBody() {
  raw_ostream &os = bodyOutputStream;
  writeUleb128(os, WasmSym::startFunction->getFunctionIndex(),
               "function index");
}

void ElemSection::addEntry(FunctionSymbol *sym) {
  // Don't add stub functions to the wasm table.  The address of all stub
  // functions should be zero and they should they don't appear in the table.
  // They only exist so that the calls to missing functions can validate.
  if (sym->hasTableIndex() || sym->isStub)
    return;
  sym->setTableIndex(config->tableBase + indirectFunctions.size());
  indirectFunctions.emplace_back(sym);
}

void ElemSection::writeBody() {
  raw_ostream &os = bodyOutputStream;

  assert(WasmSym::indirectFunctionTable);
  writeUleb128(os, 1, "segment count");
  uint32_t tableNumber = WasmSym::indirectFunctionTable->getTableNumber();
  uint32_t flags = 0;
  if (tableNumber)
    flags |= WASM_ELEM_SEGMENT_HAS_TABLE_NUMBER;
  writeUleb128(os, flags, "elem segment flags");
  if (flags & WASM_ELEM_SEGMENT_HAS_TABLE_NUMBER)
    writeUleb128(os, tableNumber, "table number");

  WasmInitExpr initExpr;
  if (config->isPic) {
    initExpr.Opcode = WASM_OPCODE_GLOBAL_GET;
    initExpr.Value.Global =
        (config->is64.getValueOr(false) ? WasmSym::tableBase32
                                        : WasmSym::tableBase)
            ->getGlobalIndex();
  } else {
    initExpr.Opcode = WASM_OPCODE_I32_CONST;
    initExpr.Value.Int32 = config->tableBase;
  }
  writeInitExpr(os, initExpr);

  if (flags & WASM_ELEM_SEGMENT_MASK_HAS_ELEM_KIND) {
    // We only write active function table initializers, for which the elem kind
    // is specified to be written as 0x00 and interpreted to mean "funcref".
    const uint8_t elemKind = 0;
    writeU8(os, elemKind, "elem kind");
  }

  writeUleb128(os, indirectFunctions.size(), "elem count");
  uint32_t tableIndex = config->tableBase;
  for (const FunctionSymbol *sym : indirectFunctions) {
    assert(sym->getTableIndex() == tableIndex);
    writeUleb128(os, sym->getFunctionIndex(), "function index");
    ++tableIndex;
  }
}

DataCountSection::DataCountSection(ArrayRef<OutputSegment *> segments)
    : SyntheticSection(llvm::wasm::WASM_SEC_DATACOUNT),
      numSegments(std::count_if(
          segments.begin(), segments.end(),
          [](OutputSegment *const segment) { return !segment->isBss; })) {}

void DataCountSection::writeBody() {
  writeUleb128(bodyOutputStream, numSegments, "data count");
}

bool DataCountSection::isNeeded() const {
  return numSegments && config->sharedMemory;
}

void LinkingSection::writeBody() {
  raw_ostream &os = bodyOutputStream;

  writeUleb128(os, WasmMetadataVersion, "Version");

  if (!symtabEntries.empty()) {
    SubSection sub(WASM_SYMBOL_TABLE);
    writeUleb128(sub.os, symtabEntries.size(), "num symbols");

    for (const Symbol *sym : symtabEntries) {
      assert(sym->isDefined() || sym->isUndefined());
      WasmSymbolType kind = sym->getWasmType();
      uint32_t flags = sym->flags;

      writeU8(sub.os, kind, "sym kind");
      writeUleb128(sub.os, flags, "sym flags");

      if (auto *f = dyn_cast<FunctionSymbol>(sym)) {
        if (auto *d = dyn_cast<DefinedFunction>(sym)) {
          writeUleb128(sub.os, d->getExportedFunctionIndex(), "index");
        } else {
          writeUleb128(sub.os, f->getFunctionIndex(), "index");
        }
        if (sym->isDefined() || (flags & WASM_SYMBOL_EXPLICIT_NAME) != 0)
          writeStr(sub.os, sym->getName(), "sym name");
      } else if (auto *g = dyn_cast<GlobalSymbol>(sym)) {
        writeUleb128(sub.os, g->getGlobalIndex(), "index");
        if (sym->isDefined() || (flags & WASM_SYMBOL_EXPLICIT_NAME) != 0)
          writeStr(sub.os, sym->getName(), "sym name");
      } else if (auto *t = dyn_cast<TagSymbol>(sym)) {
        writeUleb128(sub.os, t->getTagIndex(), "index");
        if (sym->isDefined() || (flags & WASM_SYMBOL_EXPLICIT_NAME) != 0)
          writeStr(sub.os, sym->getName(), "sym name");
      } else if (auto *t = dyn_cast<TableSymbol>(sym)) {
        writeUleb128(sub.os, t->getTableNumber(), "table number");
        if (sym->isDefined() || (flags & WASM_SYMBOL_EXPLICIT_NAME) != 0)
          writeStr(sub.os, sym->getName(), "sym name");
      } else if (isa<DataSymbol>(sym)) {
        writeStr(sub.os, sym->getName(), "sym name");
        if (auto *dataSym = dyn_cast<DefinedData>(sym)) {
          writeUleb128(sub.os, dataSym->getOutputSegmentIndex(), "index");
          writeUleb128(sub.os, dataSym->getOutputSegmentOffset(),
                       "data offset");
          writeUleb128(sub.os, dataSym->getSize(), "data size");
        }
      } else {
        auto *s = cast<OutputSectionSymbol>(sym);
        writeUleb128(sub.os, s->section->sectionIndex, "sym section index");
      }
    }

    sub.writeTo(os);
  }

  if (dataSegments.size()) {
    SubSection sub(WASM_SEGMENT_INFO);
    writeUleb128(sub.os, dataSegments.size(), "num data segments");
    for (const OutputSegment *s : dataSegments) {
      writeStr(sub.os, s->name, "segment name");
      writeUleb128(sub.os, s->alignment, "alignment");
      writeUleb128(sub.os, s->linkingFlags, "flags");
    }
    sub.writeTo(os);
  }

  if (!initFunctions.empty()) {
    SubSection sub(WASM_INIT_FUNCS);
    writeUleb128(sub.os, initFunctions.size(), "num init functions");
    for (const WasmInitEntry &f : initFunctions) {
      writeUleb128(sub.os, f.priority, "priority");
      writeUleb128(sub.os, f.sym->getOutputSymbolIndex(), "function index");
    }
    sub.writeTo(os);
  }

  struct ComdatEntry {
    unsigned kind;
    uint32_t index;
  };
  std::map<StringRef, std::vector<ComdatEntry>> comdats;

  for (const InputFunction *f : out.functionSec->inputFunctions) {
    StringRef comdat = f->getComdatName();
    if (!comdat.empty())
      comdats[comdat].emplace_back(
          ComdatEntry{WASM_COMDAT_FUNCTION, f->getFunctionIndex()});
  }
  for (uint32_t i = 0; i < dataSegments.size(); ++i) {
    const auto &inputSegments = dataSegments[i]->inputSegments;
    if (inputSegments.empty())
      continue;
    StringRef comdat = inputSegments[0]->getComdatName();
#ifndef NDEBUG
    for (const InputChunk *isec : inputSegments)
      assert(isec->getComdatName() == comdat);
#endif
    if (!comdat.empty())
      comdats[comdat].emplace_back(ComdatEntry{WASM_COMDAT_DATA, i});
  }

  if (!comdats.empty()) {
    SubSection sub(WASM_COMDAT_INFO);
    writeUleb128(sub.os, comdats.size(), "num comdats");
    for (const auto &c : comdats) {
      writeStr(sub.os, c.first, "comdat name");
      writeUleb128(sub.os, 0, "comdat flags"); // flags for future use
      writeUleb128(sub.os, c.second.size(), "num entries");
      for (const ComdatEntry &entry : c.second) {
        writeU8(sub.os, entry.kind, "entry kind");
        writeUleb128(sub.os, entry.index, "entry index");
      }
    }
    sub.writeTo(os);
  }
}

void LinkingSection::addToSymtab(Symbol *sym) {
  sym->setOutputSymbolIndex(symtabEntries.size());
  symtabEntries.emplace_back(sym);
}

unsigned NameSection::numNamedFunctions() const {
  unsigned numNames = out.importSec->getNumImportedFunctions();

  for (const InputFunction *f : out.functionSec->inputFunctions)
    if (!f->getName().empty() || !f->getDebugName().empty())
      ++numNames;

  return numNames;
}

unsigned NameSection::numNamedGlobals() const {
  unsigned numNames = out.importSec->getNumImportedGlobals();

  for (const InputGlobal *g : out.globalSec->inputGlobals)
    if (!g->getName().empty())
      ++numNames;

  numNames += out.globalSec->internalGotSymbols.size();
  return numNames;
}

unsigned NameSection::numNamedDataSegments() const {
  unsigned numNames = 0;

  for (const OutputSegment *s : segments)
    if (!s->name.empty() && !s->isBss)
      ++numNames;

  return numNames;
}

// Create the custom "name" section containing debug symbol names.
void NameSection::writeBody() {
  unsigned count = numNamedFunctions();
  if (count) {
    SubSection sub(WASM_NAMES_FUNCTION);
    writeUleb128(sub.os, count, "name count");

    // Function names appear in function index order.  As it happens
    // importedSymbols and inputFunctions are numbered in order with imported
    // functions coming first.
    for (const Symbol *s : out.importSec->importedSymbols) {
      if (auto *f = dyn_cast<FunctionSymbol>(s)) {
        writeUleb128(sub.os, f->getFunctionIndex(), "func index");
        writeStr(sub.os, toString(*s), "symbol name");
      }
    }
    for (const InputFunction *f : out.functionSec->inputFunctions) {
      if (!f->getName().empty()) {
        writeUleb128(sub.os, f->getFunctionIndex(), "func index");
        if (!f->getDebugName().empty()) {
          writeStr(sub.os, f->getDebugName(), "symbol name");
        } else {
          writeStr(sub.os, maybeDemangleSymbol(f->getName()), "symbol name");
        }
      }
    }
    sub.writeTo(bodyOutputStream);
  }

  count = numNamedGlobals();
  if (count) {
    SubSection sub(WASM_NAMES_GLOBAL);
    writeUleb128(sub.os, count, "name count");

    for (const Symbol *s : out.importSec->importedSymbols) {
      if (auto *g = dyn_cast<GlobalSymbol>(s)) {
        writeUleb128(sub.os, g->getGlobalIndex(), "global index");
        writeStr(sub.os, toString(*s), "symbol name");
      }
    }
    for (const Symbol *s : out.importSec->gotSymbols) {
      writeUleb128(sub.os, s->getGOTIndex(), "global index");
      writeStr(sub.os, toString(*s), "symbol name");
    }
    for (const InputGlobal *g : out.globalSec->inputGlobals) {
      if (!g->getName().empty()) {
        writeUleb128(sub.os, g->getAssignedIndex(), "global index");
        writeStr(sub.os, maybeDemangleSymbol(g->getName()), "symbol name");
      }
    }
    for (Symbol *s : out.globalSec->internalGotSymbols) {
      writeUleb128(sub.os, s->getGOTIndex(), "global index");
      if (isa<FunctionSymbol>(s))
        writeStr(sub.os, "GOT.func.internal." + toString(*s), "symbol name");
      else
        writeStr(sub.os, "GOT.data.internal." + toString(*s), "symbol name");
    }

    sub.writeTo(bodyOutputStream);
  }

  count = numNamedDataSegments();
  if (count) {
    SubSection sub(WASM_NAMES_DATA_SEGMENT);
    writeUleb128(sub.os, count, "name count");

    for (OutputSegment *s : segments) {
      if (!s->name.empty() && !s->isBss) {
        writeUleb128(sub.os, s->index, "global index");
        writeStr(sub.os, s->name, "segment name");
      }
    }

    sub.writeTo(bodyOutputStream);
  }
}

void ProducersSection::addInfo(const WasmProducerInfo &info) {
  for (auto &producers :
       {std::make_pair(&info.Languages, &languages),
        std::make_pair(&info.Tools, &tools), std::make_pair(&info.SDKs, &sDKs)})
    for (auto &producer : *producers.first)
      if (producers.second->end() ==
          llvm::find_if(*producers.second,
                        [&](std::pair<std::string, std::string> seen) {
                          return seen.first == producer.first;
                        }))
        producers.second->push_back(producer);
}

void ProducersSection::writeBody() {
  auto &os = bodyOutputStream;
  writeUleb128(os, fieldCount(), "field count");
  for (auto &field :
       {std::make_pair("language", languages),
        std::make_pair("processed-by", tools), std::make_pair("sdk", sDKs)}) {
    if (field.second.empty())
      continue;
    writeStr(os, field.first, "field name");
    writeUleb128(os, field.second.size(), "number of entries");
    for (auto &entry : field.second) {
      writeStr(os, entry.first, "producer name");
      writeStr(os, entry.second, "producer version");
    }
  }
}

void TargetFeaturesSection::writeBody() {
  SmallVector<std::string, 8> emitted(features.begin(), features.end());
  llvm::sort(emitted);
  auto &os = bodyOutputStream;
  writeUleb128(os, emitted.size(), "feature count");
  for (auto &feature : emitted) {
    writeU8(os, WASM_FEATURE_PREFIX_USED, "feature used prefix");
    writeStr(os, feature, "feature name");
  }
}

void RelocSection::writeBody() {
  uint32_t count = sec->getNumRelocations();
  assert(sec->sectionIndex != UINT32_MAX);
  writeUleb128(bodyOutputStream, sec->sectionIndex, "reloc section");
  writeUleb128(bodyOutputStream, count, "reloc count");
  sec->writeRelocations(bodyOutputStream);
}

} // namespace wasm
} // namespace lld