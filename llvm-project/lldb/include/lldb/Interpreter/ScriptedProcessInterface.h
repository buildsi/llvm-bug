//===-- ScriptedProcessInterface.h ------------------------------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef LLDB_INTERPRETER_SCRIPTEDPROCESSINTERFACE_H
#define LLDB_INTERPRETER_SCRIPTEDPROCESSINTERFACE_H

#include "lldb/Core/StructuredDataImpl.h"
#include "lldb/Interpreter/ScriptInterpreter.h"
#include "lldb/Interpreter/ScriptedInterface.h"

#include "lldb/lldb-private.h"

#include <string>

namespace lldb_private {
class ScriptedProcessInterface : virtual public ScriptedInterface {
public:
  StructuredData::GenericSP
  CreatePluginObject(llvm::StringRef class_name, ExecutionContext &exe_ctx,
                     StructuredData::DictionarySP args_sp) override {
    return nullptr;
  }

  virtual Status Launch() { return Status("ScriptedProcess did not launch"); }

  virtual Status Resume() { return Status("ScriptedProcess did not resume"); }

  virtual bool ShouldStop() { return true; }

  virtual Status Stop() { return Status("ScriptedProcess did not stop"); }

  virtual lldb::MemoryRegionInfoSP
  GetMemoryRegionContainingAddress(lldb::addr_t address) {
    return nullptr;
  }

  virtual StructuredData::DictionarySP GetThreadWithID(lldb::tid_t tid) {
    return nullptr;
  }

  virtual StructuredData::DictionarySP GetRegistersForThread(lldb::tid_t tid) {
    return nullptr;
  }

  virtual lldb::DataExtractorSP
  ReadMemoryAtAddress(lldb::addr_t address, size_t size, Status &error) {
    return nullptr;
  }

  virtual StructuredData::DictionarySP GetLoadedImages() { return nullptr; }

  virtual lldb::pid_t GetProcessID() { return LLDB_INVALID_PROCESS_ID; }

  virtual bool IsAlive() { return true; }
};
} // namespace lldb_private

#endif // LLDB_INTERPRETER_SCRIPTEDPROCESSINTERFACE_H
