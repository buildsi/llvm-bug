; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-apple-darwin -mcpu=corei7-avx -mattr=+avx | FileCheck %s

define <4 x double> @addpd256(<4 x double> %y, <4 x double> %x) nounwind uwtable readnone ssp {
; CHECK-LABEL: addpd256:
; CHECK:       ## %bb.0: ## %entry
; CHECK-NEXT:    vaddpd %ymm0, %ymm1, %ymm0
; CHECK-NEXT:    retq
entry:
  %add.i = fadd <4 x double> %x, %y
  ret <4 x double> %add.i
}

define <4 x double> @addpd256fold(<4 x double> %y) nounwind uwtable readnone ssp {
; CHECK-LABEL: addpd256fold:
; CHECK:       ## %bb.0: ## %entry
; CHECK-NEXT:    vaddpd {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %ymm0, %ymm0
; CHECK-NEXT:    retq
entry:
  %add.i = fadd <4 x double> %y, <double 4.500000e+00, double 3.400000e+00, double 2.300000e+00, double 1.200000e+00>
  ret <4 x double> %add.i
}

define <8 x float> @addps256(<8 x float> %y, <8 x float> %x) nounwind uwtable readnone ssp {
; CHECK-LABEL: addps256:
; CHECK:       ## %bb.0: ## %entry
; CHECK-NEXT:    vaddps %ymm0, %ymm1, %ymm0
; CHECK-NEXT:    retq
entry:
  %add.i = fadd <8 x float> %x, %y
  ret <8 x float> %add.i
}

define <8 x float> @addps256fold(<8 x float> %y) nounwind uwtable readnone ssp {
; CHECK-LABEL: addps256fold:
; CHECK:       ## %bb.0: ## %entry
; CHECK-NEXT:    vaddps {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %ymm0, %ymm0
; CHECK-NEXT:    retq
entry:
  %add.i = fadd <8 x float> %y, <float 4.500000e+00, float 0x400B333340000000, float 0x4002666660000000, float 0x3FF3333340000000, float 4.500000e+00, float 0x400B333340000000, float 0x4002666660000000, float 0x3FF3333340000000>
  ret <8 x float> %add.i
}

define <4 x double> @subpd256(<4 x double> %y, <4 x double> %x) nounwind uwtable readnone ssp {
; CHECK-LABEL: subpd256:
; CHECK:       ## %bb.0: ## %entry
; CHECK-NEXT:    vsubpd %ymm0, %ymm1, %ymm0
; CHECK-NEXT:    retq
entry:
  %sub.i = fsub <4 x double> %x, %y
  ret <4 x double> %sub.i
}

define <4 x double> @subpd256fold(<4 x double> %y, <4 x double>* nocapture %x) nounwind uwtable readonly ssp {
; CHECK-LABEL: subpd256fold:
; CHECK:       ## %bb.0: ## %entry
; CHECK-NEXT:    vsubpd (%rdi), %ymm0, %ymm0
; CHECK-NEXT:    retq
entry:
  %tmp2 = load <4 x double>, <4 x double>* %x, align 32
  %sub.i = fsub <4 x double> %y, %tmp2
  ret <4 x double> %sub.i
}

define <8 x float> @subps256(<8 x float> %y, <8 x float> %x) nounwind uwtable readnone ssp {
; CHECK-LABEL: subps256:
; CHECK:       ## %bb.0: ## %entry
; CHECK-NEXT:    vsubps %ymm0, %ymm1, %ymm0
; CHECK-NEXT:    retq
entry:
  %sub.i = fsub <8 x float> %x, %y
  ret <8 x float> %sub.i
}

define <8 x float> @subps256fold(<8 x float> %y, <8 x float>* nocapture %x) nounwind uwtable readonly ssp {
; CHECK-LABEL: subps256fold:
; CHECK:       ## %bb.0: ## %entry
; CHECK-NEXT:    vsubps (%rdi), %ymm0, %ymm0
; CHECK-NEXT:    retq
entry:
  %tmp2 = load <8 x float>, <8 x float>* %x, align 32
  %sub.i = fsub <8 x float> %y, %tmp2
  ret <8 x float> %sub.i
}

define <4 x double> @mulpd256(<4 x double> %y, <4 x double> %x) nounwind uwtable readnone ssp {
; CHECK-LABEL: mulpd256:
; CHECK:       ## %bb.0: ## %entry
; CHECK-NEXT:    vmulpd %ymm0, %ymm1, %ymm0
; CHECK-NEXT:    retq
entry:
  %mul.i = fmul <4 x double> %x, %y
  ret <4 x double> %mul.i
}

define <4 x double> @mulpd256fold(<4 x double> %y) nounwind uwtable readnone ssp {
; CHECK-LABEL: mulpd256fold:
; CHECK:       ## %bb.0: ## %entry
; CHECK-NEXT:    vmulpd {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %ymm0, %ymm0
; CHECK-NEXT:    retq
entry:
  %mul.i = fmul <4 x double> %y, <double 4.500000e+00, double 3.400000e+00, double 2.300000e+00, double 1.200000e+00>
  ret <4 x double> %mul.i
}

define <8 x float> @mulps256(<8 x float> %y, <8 x float> %x) nounwind uwtable readnone ssp {
; CHECK-LABEL: mulps256:
; CHECK:       ## %bb.0: ## %entry
; CHECK-NEXT:    vmulps %ymm0, %ymm1, %ymm0
; CHECK-NEXT:    retq
entry:
  %mul.i = fmul <8 x float> %x, %y
  ret <8 x float> %mul.i
}

define <8 x float> @mulps256fold(<8 x float> %y) nounwind uwtable readnone ssp {
; CHECK-LABEL: mulps256fold:
; CHECK:       ## %bb.0: ## %entry
; CHECK-NEXT:    vmulps {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %ymm0, %ymm0
; CHECK-NEXT:    retq
entry:
  %mul.i = fmul <8 x float> %y, <float 4.500000e+00, float 0x400B333340000000, float 0x4002666660000000, float 0x3FF3333340000000, float 4.500000e+00, float 0x400B333340000000, float 0x4002666660000000, float 0x3FF3333340000000>
  ret <8 x float> %mul.i
}

define <4 x double> @divpd256(<4 x double> %y, <4 x double> %x) nounwind uwtable readnone ssp {
; CHECK-LABEL: divpd256:
; CHECK:       ## %bb.0: ## %entry
; CHECK-NEXT:    vdivpd %ymm0, %ymm1, %ymm0
; CHECK-NEXT:    retq
entry:
  %div.i = fdiv <4 x double> %x, %y
  ret <4 x double> %div.i
}

define <4 x double> @divpd256fold(<4 x double> %y) nounwind uwtable readnone ssp {
; CHECK-LABEL: divpd256fold:
; CHECK:       ## %bb.0: ## %entry
; CHECK-NEXT:    vdivpd {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %ymm0, %ymm0
; CHECK-NEXT:    retq
entry:
  %div.i = fdiv <4 x double> %y, <double 4.500000e+00, double 3.400000e+00, double 2.300000e+00, double 1.200000e+00>
  ret <4 x double> %div.i
}

define <8 x float> @divps256(<8 x float> %y, <8 x float> %x) nounwind uwtable readnone ssp {
; CHECK-LABEL: divps256:
; CHECK:       ## %bb.0: ## %entry
; CHECK-NEXT:    vdivps %ymm0, %ymm1, %ymm0
; CHECK-NEXT:    retq
entry:
  %div.i = fdiv <8 x float> %x, %y
  ret <8 x float> %div.i
}

define <8 x float> @divps256fold(<8 x float> %y) nounwind uwtable readnone ssp {
; CHECK-LABEL: divps256fold:
; CHECK:       ## %bb.0: ## %entry
; CHECK-NEXT:    vdivps {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %ymm0, %ymm0
; CHECK-NEXT:    retq
entry:
  %div.i = fdiv <8 x float> %y, <float 4.500000e+00, float 0x400B333340000000, float 0x4002666660000000, float 0x3FF3333340000000, float 4.500000e+00, float 0x400B333340000000, float 0x4002666660000000, float 0x3FF3333340000000>
  ret <8 x float> %div.i
}

define float @sqrtA(float %a) nounwind uwtable readnone ssp {
; CHECK-LABEL: sqrtA:
; CHECK:       ## %bb.0: ## %entry
; CHECK-NEXT:    vsqrtss %xmm0, %xmm0, %xmm0
; CHECK-NEXT:    retq
entry:
  %conv1 = tail call float @sqrtf(float %a) nounwind readnone
  ret float %conv1
}

declare double @sqrt(double) readnone

define double @sqrtB(double %a) nounwind uwtable readnone ssp {
; CHECK-LABEL: sqrtB:
; CHECK:       ## %bb.0: ## %entry
; CHECK-NEXT:    vsqrtsd %xmm0, %xmm0, %xmm0
; CHECK-NEXT:    retq
entry:
  %call = tail call double @sqrt(double %a) nounwind readnone
  ret double %call
}

declare float @sqrtf(float) readnone


define <4 x i64> @vpaddq(<4 x i64> %i, <4 x i64> %j) nounwind readnone {
; CHECK-LABEL: vpaddq:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vextractf128 $1, %ymm1, %xmm2
; CHECK-NEXT:    vextractf128 $1, %ymm0, %xmm3
; CHECK-NEXT:    vpaddq %xmm2, %xmm3, %xmm2
; CHECK-NEXT:    vpaddq %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    vinsertf128 $1, %xmm2, %ymm0, %ymm0
; CHECK-NEXT:    retq
  %x = add <4 x i64> %i, %j
  ret <4 x i64> %x
}

define <8 x i32> @vpaddd(<8 x i32> %i, <8 x i32> %j) nounwind readnone {
; CHECK-LABEL: vpaddd:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vextractf128 $1, %ymm1, %xmm2
; CHECK-NEXT:    vextractf128 $1, %ymm0, %xmm3
; CHECK-NEXT:    vpaddd %xmm2, %xmm3, %xmm2
; CHECK-NEXT:    vpaddd %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    vinsertf128 $1, %xmm2, %ymm0, %ymm0
; CHECK-NEXT:    retq
  %x = add <8 x i32> %i, %j
  ret <8 x i32> %x
}

define <16 x i16> @vpaddw(<16 x i16> %i, <16 x i16> %j) nounwind readnone {
; CHECK-LABEL: vpaddw:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vextractf128 $1, %ymm1, %xmm2
; CHECK-NEXT:    vextractf128 $1, %ymm0, %xmm3
; CHECK-NEXT:    vpaddw %xmm2, %xmm3, %xmm2
; CHECK-NEXT:    vpaddw %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    vinsertf128 $1, %xmm2, %ymm0, %ymm0
; CHECK-NEXT:    retq
  %x = add <16 x i16> %i, %j
  ret <16 x i16> %x
}

define <32 x i8> @vpaddb(<32 x i8> %i, <32 x i8> %j) nounwind readnone {
; CHECK-LABEL: vpaddb:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vextractf128 $1, %ymm1, %xmm2
; CHECK-NEXT:    vextractf128 $1, %ymm0, %xmm3
; CHECK-NEXT:    vpaddb %xmm2, %xmm3, %xmm2
; CHECK-NEXT:    vpaddb %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    vinsertf128 $1, %xmm2, %ymm0, %ymm0
; CHECK-NEXT:    retq
  %x = add <32 x i8> %i, %j
  ret <32 x i8> %x
}

define <4 x i64> @vpsubq(<4 x i64> %i, <4 x i64> %j) nounwind readnone {
; CHECK-LABEL: vpsubq:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vextractf128 $1, %ymm1, %xmm2
; CHECK-NEXT:    vextractf128 $1, %ymm0, %xmm3
; CHECK-NEXT:    vpsubq %xmm2, %xmm3, %xmm2
; CHECK-NEXT:    vpsubq %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    vinsertf128 $1, %xmm2, %ymm0, %ymm0
; CHECK-NEXT:    retq
  %x = sub <4 x i64> %i, %j
  ret <4 x i64> %x
}

define <8 x i32> @vpsubd(<8 x i32> %i, <8 x i32> %j) nounwind readnone {
; CHECK-LABEL: vpsubd:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vextractf128 $1, %ymm1, %xmm2
; CHECK-NEXT:    vextractf128 $1, %ymm0, %xmm3
; CHECK-NEXT:    vpsubd %xmm2, %xmm3, %xmm2
; CHECK-NEXT:    vpsubd %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    vinsertf128 $1, %xmm2, %ymm0, %ymm0
; CHECK-NEXT:    retq
  %x = sub <8 x i32> %i, %j
  ret <8 x i32> %x
}

define <16 x i16> @vpsubw(<16 x i16> %i, <16 x i16> %j) nounwind readnone {
; CHECK-LABEL: vpsubw:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vextractf128 $1, %ymm1, %xmm2
; CHECK-NEXT:    vextractf128 $1, %ymm0, %xmm3
; CHECK-NEXT:    vpsubw %xmm2, %xmm3, %xmm2
; CHECK-NEXT:    vpsubw %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    vinsertf128 $1, %xmm2, %ymm0, %ymm0
; CHECK-NEXT:    retq
  %x = sub <16 x i16> %i, %j
  ret <16 x i16> %x
}

define <32 x i8> @vpsubb(<32 x i8> %i, <32 x i8> %j) nounwind readnone {
; CHECK-LABEL: vpsubb:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vextractf128 $1, %ymm1, %xmm2
; CHECK-NEXT:    vextractf128 $1, %ymm0, %xmm3
; CHECK-NEXT:    vpsubb %xmm2, %xmm3, %xmm2
; CHECK-NEXT:    vpsubb %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    vinsertf128 $1, %xmm2, %ymm0, %ymm0
; CHECK-NEXT:    retq
  %x = sub <32 x i8> %i, %j
  ret <32 x i8> %x
}

define <8 x i32> @vpmulld(<8 x i32> %i, <8 x i32> %j) nounwind readnone {
; CHECK-LABEL: vpmulld:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vextractf128 $1, %ymm1, %xmm2
; CHECK-NEXT:    vextractf128 $1, %ymm0, %xmm3
; CHECK-NEXT:    vpmulld %xmm2, %xmm3, %xmm2
; CHECK-NEXT:    vpmulld %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    vinsertf128 $1, %xmm2, %ymm0, %ymm0
; CHECK-NEXT:    retq
  %x = mul <8 x i32> %i, %j
  ret <8 x i32> %x
}

define <16 x i16> @vpmullw(<16 x i16> %i, <16 x i16> %j) nounwind readnone {
; CHECK-LABEL: vpmullw:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vextractf128 $1, %ymm1, %xmm2
; CHECK-NEXT:    vextractf128 $1, %ymm0, %xmm3
; CHECK-NEXT:    vpmullw %xmm2, %xmm3, %xmm2
; CHECK-NEXT:    vpmullw %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    vinsertf128 $1, %xmm2, %ymm0, %ymm0
; CHECK-NEXT:    retq
  %x = mul <16 x i16> %i, %j
  ret <16 x i16> %x
}

define <4 x i64> @mul_v4i64(<4 x i64> %i, <4 x i64> %j) nounwind readnone {
; CHECK-LABEL: mul_v4i64:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vextractf128 $1, %ymm1, %xmm2
; CHECK-NEXT:    vextractf128 $1, %ymm0, %xmm3
; CHECK-NEXT:    vpsrlq $32, %xmm3, %xmm4
; CHECK-NEXT:    vpmuludq %xmm2, %xmm4, %xmm4
; CHECK-NEXT:    vpsrlq $32, %xmm2, %xmm5
; CHECK-NEXT:    vpmuludq %xmm5, %xmm3, %xmm5
; CHECK-NEXT:    vpaddq %xmm4, %xmm5, %xmm4
; CHECK-NEXT:    vpsllq $32, %xmm4, %xmm4
; CHECK-NEXT:    vpmuludq %xmm2, %xmm3, %xmm2
; CHECK-NEXT:    vpaddq %xmm4, %xmm2, %xmm2
; CHECK-NEXT:    vpsrlq $32, %xmm0, %xmm3
; CHECK-NEXT:    vpmuludq %xmm1, %xmm3, %xmm3
; CHECK-NEXT:    vpsrlq $32, %xmm1, %xmm4
; CHECK-NEXT:    vpmuludq %xmm4, %xmm0, %xmm4
; CHECK-NEXT:    vpaddq %xmm3, %xmm4, %xmm3
; CHECK-NEXT:    vpsllq $32, %xmm3, %xmm3
; CHECK-NEXT:    vpmuludq %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    vpaddq %xmm3, %xmm0, %xmm0
; CHECK-NEXT:    vinsertf128 $1, %xmm2, %ymm0, %ymm0
; CHECK-NEXT:    retq
  %x = mul <4 x i64> %i, %j
  ret <4 x i64> %x
}

declare <4 x float> @llvm.x86.sse.sqrt.ss(<4 x float>) nounwind readnone

define <4 x float> @int_sqrt_ss() {
; CHECK-LABEL: int_sqrt_ss:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vmovss {{.*#+}} xmm0 = mem[0],zero,zero,zero
; CHECK-NEXT:    vsqrtss %xmm0, %xmm0, %xmm0
; CHECK-NEXT:    retq
 %x0 = load float, float addrspace(1)* undef, align 8
 %x1 = insertelement <4 x float> undef, float %x0, i32 0
 %x2 = call <4 x float> @llvm.x86.sse.sqrt.ss(<4 x float> %x1) nounwind
 ret <4 x float> %x2
}

define <2 x double> @vector_sqrt_scalar_load(double* %a0) optsize {
; CHECK-LABEL: vector_sqrt_scalar_load:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vmovsd {{.*#+}} xmm0 = mem[0],zero
; CHECK-NEXT:    vsqrtpd %xmm0, %xmm0
; CHECK-NEXT:    retq
  %a1 = load double, double* %a0
  %a2 = insertelement <2 x double> undef, double %a1, i32 0
  %res = call <2 x double> @llvm.sqrt.v2f64(<2 x double> %a2) ; <<2 x double>> [#uses=1]
  ret <2 x double> %res
}
declare <2 x double> @llvm.sqrt.v2f64(<2 x double>) nounwind readnone