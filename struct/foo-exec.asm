foo-exec:     file format elf64-x86-64


Disassembly of section .init:

0000000000401000 <_init>:
  401000:	f3 0f 1e fa          	endbr64 
  401004:	48 83 ec 08          	sub    $0x8,%rsp
  401008:	48 8b 05 e9 2f 00 00 	mov    0x2fe9(%rip),%rax        # 403ff8 <__gmon_start__>
  40100f:	48 85 c0             	test   %rax,%rax
  401012:	74 02                	je     401016 <_init+0x16>
  401014:	ff d0                	call   *%rax
  401016:	48 83 c4 08          	add    $0x8,%rsp
  40101a:	c3                   	ret    

Disassembly of section .plt:

0000000000401020 <__cxa_atexit@plt-0x10>:
  401020:	ff 35 e2 2f 00 00    	push   0x2fe2(%rip)        # 404008 <_GLOBAL_OFFSET_TABLE_+0x8>
  401026:	ff 25 e4 2f 00 00    	jmp    *0x2fe4(%rip)        # 404010 <_GLOBAL_OFFSET_TABLE_+0x10>
  40102c:	0f 1f 40 00          	nopl   0x0(%rax)

0000000000401030 <__cxa_atexit@plt>:
  401030:	ff 25 e2 2f 00 00    	jmp    *0x2fe2(%rip)        # 404018 <__cxa_atexit@GLIBC_2.2.5>
  401036:	68 00 00 00 00       	push   $0x0
  40103b:	e9 e0 ff ff ff       	jmp    401020 <_init+0x20>

0000000000401040 <_Z8Function1A1BPhePyde@plt>:
  401040:	ff 25 da 2f 00 00    	jmp    *0x2fda(%rip)        # 404020 <_Z8Function1A1BPhePyde>
  401046:	68 01 00 00 00       	push   $0x1
  40104b:	e9 d0 ff ff ff       	jmp    401020 <_init+0x20>

0000000000401050 <_ZNSt8ios_base4InitC1Ev@plt>:
  401050:	ff 25 d2 2f 00 00    	jmp    *0x2fd2(%rip)        # 404028 <_ZNSt8ios_base4InitC1Ev@GLIBCXX_3.4>
  401056:	68 02 00 00 00       	push   $0x2
  40105b:	e9 c0 ff ff ff       	jmp    401020 <_init+0x20>

0000000000401060 <_ZNSt8ios_base4InitD1Ev@plt>:
  401060:	ff 25 ca 2f 00 00    	jmp    *0x2fca(%rip)        # 404030 <_ZNSt8ios_base4InitD1Ev@GLIBCXX_3.4>
  401066:	68 03 00 00 00       	push   $0x3
  40106b:	e9 b0 ff ff ff       	jmp    401020 <_init+0x20>

Disassembly of section .text:

0000000000401070 <__cxx_global_var_init>:
  401070:	55                   	push   %rbp
  401071:	48 89 e5             	mov    %rsp,%rbp
  401074:	48 bf 70 40 40 00 00 	movabs $0x404070,%rdi
  40107b:	00 00 00 
  40107e:	e8 cd ff ff ff       	call   401050 <_ZNSt8ios_base4InitC1Ev@plt>
  401083:	48 bf 60 10 40 00 00 	movabs $0x401060,%rdi
  40108a:	00 00 00 
  40108d:	48 be 70 40 40 00 00 	movabs $0x404070,%rsi
  401094:	00 00 00 
  401097:	48 ba 40 40 40 00 00 	movabs $0x404040,%rdx
  40109e:	00 00 00 
  4010a1:	e8 8a ff ff ff       	call   401030 <__cxa_atexit@plt>
  4010a6:	5d                   	pop    %rbp
  4010a7:	c3                   	ret    
  4010a8:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  4010af:	00 

00000000004010b0 <_GLOBAL__sub_I_main.c>:
  4010b0:	55                   	push   %rbp
  4010b1:	48 89 e5             	mov    %rsp,%rbp
  4010b4:	e8 b7 ff ff ff       	call   401070 <__cxx_global_var_init>
  4010b9:	5d                   	pop    %rbp
  4010ba:	c3                   	ret    
  4010bb:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)

00000000004010c0 <_start>:
  4010c0:	f3 0f 1e fa          	endbr64 
  4010c4:	31 ed                	xor    %ebp,%ebp
  4010c6:	49 89 d1             	mov    %rdx,%r9
  4010c9:	5e                   	pop    %rsi
  4010ca:	48 89 e2             	mov    %rsp,%rdx
  4010cd:	48 83 e4 f0          	and    $0xfffffffffffffff0,%rsp
  4010d1:	50                   	push   %rax
  4010d2:	54                   	push   %rsp
  4010d3:	49 c7 c0 c0 14 40 00 	mov    $0x4014c0,%r8
  4010da:	48 c7 c1 50 14 40 00 	mov    $0x401450,%rcx
  4010e1:	48 c7 c7 b0 11 40 00 	mov    $0x4011b0,%rdi
  4010e8:	ff 15 02 2f 00 00    	call   *0x2f02(%rip)        # 403ff0 <__libc_start_main@GLIBC_2.2.5>
  4010ee:	f4                   	hlt    
  4010ef:	90                   	nop

00000000004010f0 <_dl_relocate_static_pie>:
  4010f0:	f3 0f 1e fa          	endbr64 
  4010f4:	c3                   	ret    
  4010f5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  4010fc:	00 00 00 
  4010ff:	90                   	nop

0000000000401100 <deregister_tm_clones>:
  401100:	b8 48 40 40 00       	mov    $0x404048,%eax
  401105:	48 3d 48 40 40 00    	cmp    $0x404048,%rax
  40110b:	74 13                	je     401120 <deregister_tm_clones+0x20>
  40110d:	b8 00 00 00 00       	mov    $0x0,%eax
  401112:	48 85 c0             	test   %rax,%rax
  401115:	74 09                	je     401120 <deregister_tm_clones+0x20>
  401117:	bf 48 40 40 00       	mov    $0x404048,%edi
  40111c:	ff e0                	jmp    *%rax
  40111e:	66 90                	xchg   %ax,%ax
  401120:	c3                   	ret    
  401121:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
  401128:	00 00 00 00 
  40112c:	0f 1f 40 00          	nopl   0x0(%rax)

0000000000401130 <register_tm_clones>:
  401130:	be 48 40 40 00       	mov    $0x404048,%esi
  401135:	48 81 ee 48 40 40 00 	sub    $0x404048,%rsi
  40113c:	48 89 f0             	mov    %rsi,%rax
  40113f:	48 c1 ee 3f          	shr    $0x3f,%rsi
  401143:	48 c1 f8 03          	sar    $0x3,%rax
  401147:	48 01 c6             	add    %rax,%rsi
  40114a:	48 d1 fe             	sar    %rsi
  40114d:	74 11                	je     401160 <register_tm_clones+0x30>
  40114f:	b8 00 00 00 00       	mov    $0x0,%eax
  401154:	48 85 c0             	test   %rax,%rax
  401157:	74 07                	je     401160 <register_tm_clones+0x30>
  401159:	bf 48 40 40 00       	mov    $0x404048,%edi
  40115e:	ff e0                	jmp    *%rax
  401160:	c3                   	ret    
  401161:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
  401168:	00 00 00 00 
  40116c:	0f 1f 40 00          	nopl   0x0(%rax)

0000000000401170 <__do_global_dtors_aux>:
  401170:	f3 0f 1e fa          	endbr64 
  401174:	80 3d d5 2e 00 00 00 	cmpb   $0x0,0x2ed5(%rip)        # 404050 <completed.0>
  40117b:	75 13                	jne    401190 <__do_global_dtors_aux+0x20>
  40117d:	55                   	push   %rbp
  40117e:	48 89 e5             	mov    %rsp,%rbp
  401181:	e8 7a ff ff ff       	call   401100 <deregister_tm_clones>
  401186:	c6 05 c3 2e 00 00 01 	movb   $0x1,0x2ec3(%rip)        # 404050 <completed.0>
  40118d:	5d                   	pop    %rbp
  40118e:	c3                   	ret    
  40118f:	90                   	nop
  401190:	c3                   	ret    
  401191:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
  401198:	00 00 00 00 
  40119c:	0f 1f 40 00          	nopl   0x0(%rax)

00000000004011a0 <frame_dummy>:
  4011a0:	f3 0f 1e fa          	endbr64 
  4011a4:	eb 8a                	jmp    401130 <register_tm_clones>
  4011a6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  4011ad:	00 00 00 

00000000004011b0 <main>:
  4011b0:	55                   	push   %rbp
  4011b1:	48 89 e5             	mov    %rsp,%rbp
  4011b4:	48 81 ec 10 02 00 00 	sub    $0x210,%rsp
  4011bb:	48 b8 04 60 11 69 22 	movabs $0x984962269116004,%rax
  4011c2:	96 84 09 
  4011c5:	48 89 05 94 2e 00 00 	mov    %rax,0x2e94(%rip)        # 404060 <fpIntPkkpmemvypimt>
  4011cc:	48 c7 05 91 2e 00 00 	movq   $0x0,0x2e91(%rip)        # 404068 <fpIntPkkpmemvypimt+0x8>
  4011d3:	00 00 00 00 
  4011d7:	48 b8 25 23 22 55 86 	movabs $0x5074348655222325,%rax
  4011de:	34 74 50 
  4011e1:	48 89 05 78 2e 00 00 	mov    %rax,0x2e78(%rip)        # 404060 <fpIntPkkpmemvypimt>
  4011e8:	48 c7 05 75 2e 00 00 	movq   $0x0,0x2e75(%rip)        # 404068 <fpIntPkkpmemvypimt+0x8>
  4011ef:	00 00 00 00 
  4011f3:	48 8d 7d e0          	lea    -0x20(%rbp),%rdi
  4011f7:	e8 94 01 00 00       	call   401390 <_ZN1AC2Ev>
  4011fc:	48 8d bd 70 ff ff ff 	lea    -0x90(%rbp),%rdi
  401203:	e8 c8 01 00 00       	call   4013d0 <_ZN1BC2Ev>
  401208:	c6 85 6f ff ff ff 62 	movb   $0x62,-0x91(%rbp)
  40120f:	dd 05 f3 0d 00 00    	fldl   0xdf3(%rip)        # 402008 <_IO_stdin_used+0x8>
  401215:	db bd 50 ff ff ff    	fstpt  -0xb0(%rbp)
  40121b:	48 b8 89 e4 e1 86 51 	movabs $0x585186e1e489,%rax
  401222:	58 00 00 
  401225:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
  40122c:	48 b8 93 d8 5e 2f 0d 	movabs $0x420db50d2f5ed893,%rax
  401233:	b5 0d 42 
  401236:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  40123d:	dd 05 cd 0d 00 00    	fldl   0xdcd(%rip)        # 402010 <_IO_stdin_used+0x10>
  401243:	db bd 30 ff ff ff    	fstpt  -0xd0(%rbp)
  401249:	48 8b 05 10 2e 00 00 	mov    0x2e10(%rip),%rax        # 404060 <fpIntPkkpmemvypimt>
  401250:	48 8b 0d 11 2e 00 00 	mov    0x2e11(%rip),%rcx        # 404068 <fpIntPkkpmemvypimt+0x8>
  401257:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  40125b:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  40125f:	48 8b 05 fa 2d 00 00 	mov    0x2dfa(%rip),%rax        # 404060 <fpIntPkkpmemvypimt>
  401266:	48 8b 0d fb 2d 00 00 	mov    0x2dfb(%rip),%rcx        # 404068 <fpIntPkkpmemvypimt+0x8>
  40126d:	48 89 4d d8          	mov    %rcx,-0x28(%rbp)
  401271:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  401275:	0f 10 45 e0          	movups -0x20(%rbp),%xmm0
  401279:	0f 10 4d f0          	movups -0x10(%rbp),%xmm1
  40127d:	0f 29 8d 20 ff ff ff 	movaps %xmm1,-0xe0(%rbp)
  401284:	0f 29 85 10 ff ff ff 	movaps %xmm0,-0xf0(%rbp)
  40128b:	0f 28 45 d0          	movaps -0x30(%rbp),%xmm0
  40128f:	0f 29 85 00 ff ff ff 	movaps %xmm0,-0x100(%rbp)
  401296:	0f 28 45 c0          	movaps -0x40(%rbp),%xmm0
  40129a:	0f 29 85 f0 fe ff ff 	movaps %xmm0,-0x110(%rbp)
  4012a1:	0f 28 45 b0          	movaps -0x50(%rbp),%xmm0
  4012a5:	0f 29 85 e0 fe ff ff 	movaps %xmm0,-0x120(%rbp)
  4012ac:	0f 28 85 70 ff ff ff 	movaps -0x90(%rbp),%xmm0
  4012b3:	0f 28 4d 80          	movaps -0x80(%rbp),%xmm1
  4012b7:	0f 28 55 90          	movaps -0x70(%rbp),%xmm2
  4012bb:	0f 28 5d a0          	movaps -0x60(%rbp),%xmm3
  4012bf:	0f 29 9d d0 fe ff ff 	movaps %xmm3,-0x130(%rbp)
  4012c6:	0f 29 95 c0 fe ff ff 	movaps %xmm2,-0x140(%rbp)
  4012cd:	0f 29 8d b0 fe ff ff 	movaps %xmm1,-0x150(%rbp)
  4012d4:	0f 29 85 a0 fe ff ff 	movaps %xmm0,-0x160(%rbp)
  4012db:	db ad 50 ff ff ff    	fldt   -0xb0(%rbp)
  4012e1:	f2 0f 10 85 40 ff ff 	movsd  -0xc0(%rbp),%xmm0
  4012e8:	ff 
  4012e9:	db ad 30 ff ff ff    	fldt   -0xd0(%rbp)
  4012ef:	0f 28 8d 00 ff ff ff 	movaps -0x100(%rbp),%xmm1
  4012f6:	48 89 e0             	mov    %rsp,%rax
  4012f9:	0f 29 88 80 00 00 00 	movaps %xmm1,0x80(%rax)
  401300:	0f 28 8d f0 fe ff ff 	movaps -0x110(%rbp),%xmm1
  401307:	0f 29 48 70          	movaps %xmm1,0x70(%rax)
  40130b:	0f 28 8d e0 fe ff ff 	movaps -0x120(%rbp),%xmm1
  401312:	0f 29 48 60          	movaps %xmm1,0x60(%rax)
  401316:	0f 28 8d a0 fe ff ff 	movaps -0x160(%rbp),%xmm1
  40131d:	0f 28 95 b0 fe ff ff 	movaps -0x150(%rbp),%xmm2
  401324:	0f 28 9d c0 fe ff ff 	movaps -0x140(%rbp),%xmm3
  40132b:	0f 28 a5 d0 fe ff ff 	movaps -0x130(%rbp),%xmm4
  401332:	0f 29 60 50          	movaps %xmm4,0x50(%rax)
  401336:	0f 29 58 40          	movaps %xmm3,0x40(%rax)
  40133a:	0f 29 50 30          	movaps %xmm2,0x30(%rax)
  40133e:	0f 29 48 20          	movaps %xmm1,0x20(%rax)
  401342:	0f 10 8d 10 ff ff ff 	movups -0xf0(%rbp),%xmm1
  401349:	0f 10 95 20 ff ff ff 	movups -0xe0(%rbp),%xmm2
  401350:	0f 11 50 10          	movups %xmm2,0x10(%rax)
  401354:	0f 11 08             	movups %xmm1,(%rax)
  401357:	db b8 a0 00 00 00    	fstpt  0xa0(%rax)
  40135d:	db b8 90 00 00 00    	fstpt  0x90(%rax)
  401363:	48 8d bd 6f ff ff ff 	lea    -0x91(%rbp),%rdi
  40136a:	48 8d b5 48 ff ff ff 	lea    -0xb8(%rbp),%rsi
  401371:	e8 ca fc ff ff       	call   401040 <_Z8Function1A1BPhePyde@plt>
  401376:	31 c0                	xor    %eax,%eax
  401378:	48 81 c4 10 02 00 00 	add    $0x210,%rsp
  40137f:	5d                   	pop    %rbp
  401380:	c3                   	ret    
  401381:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  401388:	00 00 00 
  40138b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)

0000000000401390 <_ZN1AC2Ev>:
  401390:	55                   	push   %rbp
  401391:	48 89 e5             	mov    %rsp,%rbp
  401394:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  401398:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  40139c:	f3 0f 10 05 8c 0c 00 	movss  0xc8c(%rip),%xmm0        # 402030 <_IO_stdin_used+0x30>
  4013a3:	00 
  4013a4:	f3 0f 11 00          	movss  %xmm0,(%rax)
  4013a8:	c6 40 04 6e          	movb   $0x6e,0x4(%rax)
  4013ac:	48 c7 40 08 4b 89 00 	movq   $0x894b,0x8(%rax)
  4013b3:	00 
  4013b4:	f2 0f 10 05 64 0c 00 	movsd  0xc64(%rip),%xmm0        # 402020 <_IO_stdin_used+0x20>
  4013bb:	00 
  4013bc:	f2 0f 11 40 10       	movsd  %xmm0,0x10(%rax)
  4013c1:	f2 0f 10 05 4f 0c 00 	movsd  0xc4f(%rip),%xmm0        # 402018 <_IO_stdin_used+0x18>
  4013c8:	00 
  4013c9:	f2 0f 11 40 18       	movsd  %xmm0,0x18(%rax)
  4013ce:	5d                   	pop    %rbp
  4013cf:	c3                   	ret    

00000000004013d0 <_ZN1BC2Ev>:
  4013d0:	55                   	push   %rbp
  4013d1:	48 89 e5             	mov    %rsp,%rbp
  4013d4:	48 83 ec 10          	sub    $0x10,%rsp
  4013d8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  4013dc:	48 8b 7d f8          	mov    -0x8(%rbp),%rdi
  4013e0:	48 89 7d f0          	mov    %rdi,-0x10(%rbp)
  4013e4:	c7 07 76 a5 d5 a1    	movl   $0xa1d5a576,(%rdi)
  4013ea:	c7 47 04 a2 d4 79 7b 	movl   $0x7b79d4a2,0x4(%rdi)
  4013f1:	66 c7 47 08 5c 9b    	movw   $0x9b5c,0x8(%rdi)
  4013f7:	dd 05 2b 0c 00 00    	fldl   0xc2b(%rip)        # 402028 <_IO_stdin_used+0x28>
  4013fd:	db 7f 10             	fstpt  0x10(%rdi)
  401400:	c7 47 20 8a c1 24 55 	movl   $0x5524c18a,0x20(%rdi)
  401407:	c7 47 24 05 8b 2f 50 	movl   $0x502f8b05,0x24(%rdi)
  40140e:	48 83 c7 28          	add    $0x28,%rdi
  401412:	e8 79 ff ff ff       	call   401390 <_ZN1AC2Ev>
  401417:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  40141b:	48 8b 0d 3e 2c 00 00 	mov    0x2c3e(%rip),%rcx        # 404060 <fpIntPkkpmemvypimt>
  401422:	48 8b 15 3f 2c 00 00 	mov    0x2c3f(%rip),%rdx        # 404068 <fpIntPkkpmemvypimt+0x8>
  401429:	48 89 50 58          	mov    %rdx,0x58(%rax)
  40142d:	48 89 48 50          	mov    %rcx,0x50(%rax)
  401431:	48 8b 0d 28 2c 00 00 	mov    0x2c28(%rip),%rcx        # 404060 <fpIntPkkpmemvypimt>
  401438:	48 8b 15 29 2c 00 00 	mov    0x2c29(%rip),%rdx        # 404068 <fpIntPkkpmemvypimt+0x8>
  40143f:	48 89 50 68          	mov    %rdx,0x68(%rax)
  401443:	48 89 48 60          	mov    %rcx,0x60(%rax)
  401447:	48 83 c4 10          	add    $0x10,%rsp
  40144b:	5d                   	pop    %rbp
  40144c:	c3                   	ret    
  40144d:	0f 1f 00             	nopl   (%rax)

0000000000401450 <__libc_csu_init>:
  401450:	f3 0f 1e fa          	endbr64 
  401454:	41 57                	push   %r15
  401456:	4c 8d 3d 5b 29 00 00 	lea    0x295b(%rip),%r15        # 403db8 <__frame_dummy_init_array_entry>
  40145d:	41 56                	push   %r14
  40145f:	49 89 d6             	mov    %rdx,%r14
  401462:	41 55                	push   %r13
  401464:	49 89 f5             	mov    %rsi,%r13
  401467:	41 54                	push   %r12
  401469:	41 89 fc             	mov    %edi,%r12d
  40146c:	55                   	push   %rbp
  40146d:	48 8d 2d 54 29 00 00 	lea    0x2954(%rip),%rbp        # 403dc8 <__do_global_dtors_aux_fini_array_entry>
  401474:	53                   	push   %rbx
  401475:	4c 29 fd             	sub    %r15,%rbp
  401478:	48 83 ec 08          	sub    $0x8,%rsp
  40147c:	e8 7f fb ff ff       	call   401000 <_init>
  401481:	48 c1 fd 03          	sar    $0x3,%rbp
  401485:	74 1f                	je     4014a6 <__libc_csu_init+0x56>
  401487:	31 db                	xor    %ebx,%ebx
  401489:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  401490:	4c 89 f2             	mov    %r14,%rdx
  401493:	4c 89 ee             	mov    %r13,%rsi
  401496:	44 89 e7             	mov    %r12d,%edi
  401499:	41 ff 14 df          	call   *(%r15,%rbx,8)
  40149d:	48 83 c3 01          	add    $0x1,%rbx
  4014a1:	48 39 dd             	cmp    %rbx,%rbp
  4014a4:	75 ea                	jne    401490 <__libc_csu_init+0x40>
  4014a6:	48 83 c4 08          	add    $0x8,%rsp
  4014aa:	5b                   	pop    %rbx
  4014ab:	5d                   	pop    %rbp
  4014ac:	41 5c                	pop    %r12
  4014ae:	41 5d                	pop    %r13
  4014b0:	41 5e                	pop    %r14
  4014b2:	41 5f                	pop    %r15
  4014b4:	c3                   	ret    
  4014b5:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
  4014bc:	00 00 00 00 

00000000004014c0 <__libc_csu_fini>:
  4014c0:	f3 0f 1e fa          	endbr64 
  4014c4:	c3                   	ret    

Disassembly of section .fini:

00000000004014c8 <_fini>:
  4014c8:	f3 0f 1e fa          	endbr64 
  4014cc:	48 83 ec 08          	sub    $0x8,%rsp
  4014d0:	48 83 c4 08          	add    $0x8,%rsp
  4014d4:	c3                   	ret
