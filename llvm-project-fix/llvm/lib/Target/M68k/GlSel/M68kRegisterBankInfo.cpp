//===-- M68kRegisterBankInfo.cpp -------------------------------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
/// \file
/// This file implements the targeting of the RegisterBankInfo class for M68k.
/// \todo This should be generated by TableGen.
//===----------------------------------------------------------------------===//

#include "M68kRegisterBankInfo.h"
#include "M68kInstrInfo.h" // For the register classes
#include "M68kSubtarget.h"
#include "llvm/CodeGen/GlobalISel/RegisterBank.h"
#include "llvm/CodeGen/GlobalISel/RegisterBankInfo.h"
#include "llvm/CodeGen/MachineRegisterInfo.h"
#include "llvm/CodeGen/TargetRegisterInfo.h"

#define GET_TARGET_REGBANK_IMPL
#include "M68kGenRegisterBank.inc"

using namespace llvm;

// FIXME: TableGen this.
// If it grows too much and TableGen still isn't ready to do the job, extract it
// into an M68kGenRegisterBankInfo.def (similar to AArch64).
namespace llvm {
namespace M68k {
enum PartialMappingIdx {
  PMI_GPR,
  PMI_Min = PMI_GPR,
};

RegisterBankInfo::PartialMapping PartMappings[]{
    // GPR Partial Mapping
    {0, 32, GPRRegBank},
};

enum ValueMappingIdx {
  InvalidIdx = 0,
  GPR3OpsIdx = 1,
};

RegisterBankInfo::ValueMapping ValueMappings[] = {
    // invalid
    {nullptr, 0},
    // 3 operands in GPRs
    {&PartMappings[PMI_GPR - PMI_Min], 1},
    {&PartMappings[PMI_GPR - PMI_Min], 1},
    {&PartMappings[PMI_GPR - PMI_Min], 1},

};
} // end namespace M68k
} // end namespace llvm

M68kRegisterBankInfo::M68kRegisterBankInfo(const TargetRegisterInfo &TRI)
    : M68kGenRegisterBankInfo() {}

const RegisterBank &
M68kRegisterBankInfo::getRegBankFromRegClass(const TargetRegisterClass &RC,
                                             LLT) const {
  return getRegBank(M68k::GPRRegBankID);
}

const RegisterBankInfo::InstructionMapping &
M68kRegisterBankInfo::getInstrMapping(const MachineInstr &MI) const {
  auto Opc = MI.getOpcode();

  if (!isPreISelGenericOpcode(Opc)) {
    const InstructionMapping &Mapping = getInstrMappingImpl(MI);
    if (Mapping.isValid())
      return Mapping;
  }

  using namespace TargetOpcode;

  unsigned NumOperands = MI.getNumOperands();
  const ValueMapping *OperandsMapping = &M68k::ValueMappings[M68k::GPR3OpsIdx];

  switch (Opc) {
  case G_ADD:
  case G_SUB:
  case G_MUL:
  case G_SDIV:
  case G_UDIV:
  case G_LOAD:
  case G_STORE: {
    OperandsMapping = &M68k::ValueMappings[M68k::GPR3OpsIdx];
    break;
  }

  case G_CONSTANT:
  case G_FRAME_INDEX:
    OperandsMapping =
        getOperandsMapping({&M68k::ValueMappings[M68k::GPR3OpsIdx], nullptr});
    break;
  default:
    return getInvalidInstructionMapping();
  }

  return getInstructionMapping(DefaultMappingID, /*Cost=*/1, OperandsMapping,
                               NumOperands);
}