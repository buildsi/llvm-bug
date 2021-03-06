# RUN: %PYTHON %s | FileCheck %s

import gc
import io
import itertools
from mlir.ir import *
from mlir.dialects import builtin
# Note: std dialect needed for terminators.
from mlir.dialects import std


def run(f):
  print("\nTEST:", f.__name__)
  f()
  gc.collect()
  assert Context._get_live_count() == 0
  return f


# CHECK-LABEL: TEST: testBlockCreation
# CHECK: func @test(%[[ARG0:.*]]: i32, %[[ARG1:.*]]: i16)
# CHECK:   br ^bb1(%[[ARG1]] : i16)
# CHECK: ^bb1(%[[PHI0:.*]]: i16):
# CHECK:   br ^bb2(%[[ARG0]] : i32)
# CHECK: ^bb2(%[[PHI1:.*]]: i32):
# CHECK:   return
@run
def testBlockCreation():
  with Context() as ctx, Location.unknown():
    module = Module.create()
    with InsertionPoint(module.body):
      f_type = FunctionType.get(
          [IntegerType.get_signless(32),
           IntegerType.get_signless(16)], [])
      f_op = builtin.FuncOp("test", f_type)
      entry_block = f_op.add_entry_block()
      i32_arg, i16_arg = entry_block.arguments
      successor_block = entry_block.create_after(i32_arg.type)
      with InsertionPoint(successor_block) as successor_ip:
        assert successor_ip.block == successor_block
        std.ReturnOp([])
      middle_block = successor_block.create_before(i16_arg.type)

      with InsertionPoint(entry_block) as entry_ip:
        assert entry_ip.block == entry_block
        std.BranchOp([i16_arg], dest=middle_block)

      with InsertionPoint(middle_block) as middle_ip:
        assert middle_ip.block == middle_block
        std.BranchOp([i32_arg], dest=successor_block)
    print(module.operation)
    # Ensure region back references are coherent.
    assert entry_block.region == middle_block.region == successor_block.region
