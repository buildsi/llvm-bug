; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -basic-aa -memcpyopt -S -verify-memoryssa | FileCheck %s

target datalayout = "e"

declare void @foo(i8*)
declare void @llvm.memcpy.p0i8.p0i8.i32(i8* nocapture, i8* nocapture, i32, i1) nounwind

define void @test() {
; CHECK-LABEL: @test(
; CHECK-NEXT:    [[PTR1:%.*]] = alloca i8, align 1
; CHECK-NEXT:    [[PTR2:%.*]] = alloca i8, align 1
; CHECK-NEXT:    call void @foo(i8* [[PTR2]])
; CHECK-NEXT:    call void @llvm.memcpy.p0i8.p0i8.i32(i8* [[PTR1]], i8* [[PTR2]], i32 1, i1 false)
; CHECK-NEXT:    call void @foo(i8* [[PTR1]])
; CHECK-NEXT:    ret void
;
  %ptr1 = alloca i8
  %ptr2 = alloca i8
  call void @foo(i8* %ptr2)
  call void @llvm.memcpy.p0i8.p0i8.i32(i8* %ptr1, i8* %ptr2, i32 1, i1 false)
  call void @foo(i8* %ptr1)
  ret void

  ; Check that the transformation isn't applied if the called function can
  ; capture the pointer argument (i.e. the nocapture attribute isn't present)
}
