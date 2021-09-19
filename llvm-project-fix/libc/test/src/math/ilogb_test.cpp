//===-- Unittests for ilogb -----------------------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "ILogbTest.h"

#include "src/__support/FPUtil/FPBits.h"
#include "src/__support/FPUtil/ManipulationFunctions.h"
#include "src/__support/FPUtil/TestHelpers.h"
#include "src/math/ilogb.h"
#include "utils/UnitTest/Test.h"
#include <math.h>

TEST_F(LlvmLibcILogbTest, SpecialNumbers_ilogb) {
  testSpecialNumbers<double>(&__llvm_libc::ilogb);
}

TEST_F(LlvmLibcILogbTest, PowersOfTwo_ilogb) {
  testPowersOfTwo<double>(&__llvm_libc::ilogb);
}

TEST_F(LlvmLibcILogbTest, SomeIntegers_ilogb) {
  testSomeIntegers<double>(&__llvm_libc::ilogb);
}

TEST_F(LlvmLibcILogbTest, SubnormalRange_ilogb) {
  testSubnormalRange<double>(&__llvm_libc::ilogb);
}

TEST_F(LlvmLibcILogbTest, NormalRange_ilogb) {
  testNormalRange<double>(&__llvm_libc::ilogb);
}