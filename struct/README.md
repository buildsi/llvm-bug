# Testing Struct with big Values!

The programs included here I bound to both the llvm-project-fix and llvm-project
and ran to produce different final outputs:

## Fix

```bash
clang++ -fPIC -shared -O3 -g -Wdeprecated -o libfoo.so foo.c
clang-14: warning: treating 'c' input as 'c++' when in C++ mode, this behavior is deprecated [-Wdeprecated]
FIX: Aggregate size: 256 Lo: 7 Hi: 6triggered by Lo==Memory
FIX: Aggregate size: 256 Lo: 7 Hi: 7triggered by second to last
FIX: Final state Lo: 7 Hi: 7
FIX: Aggregate size: 384 Lo: 7 Hi: 6triggered by Lo==Memory
FIX: Aggregate size: 384 Lo: 7 Hi: 7triggered by second to last
FIX: Final state Lo: 7 Hi: 7

clang++ -O3 -o v main.c -L. -lfoo -Wl,-rpath,`pwd`
clang-14: warning: treating 'c' input as 'c++' when in C++ mode, this behavior is deprecated [-Wdeprecated]
FIX: Aggregate size: 256 Lo: 7 Hi: 6triggered by Lo==Memory
FIX: Aggregate size: 256 Lo: 7 Hi: 7triggered by second to last
FIX: Final state Lo: 7 Hi: 7
FIX: Aggregate size: 384 Lo: 7 Hi: 6triggered by Lo==Memory
FIX: Aggregate size: 384 Lo: 7 Hi: 7triggered by second to last
FIX: Final state Lo: 7 Hi: 7
```

### Assembly

Let's look at the assembly - this is for foo-exec (both use the struct that does the post-merge sequence where the differnce arises)

```bash
$ objdump -d foo-exec

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

0000000000401020 <_Z8Function27STRUCTstructYjnnzqpnshvtyqe24STRUCTstructXiodevawibeqPhePyde@plt-0x10>:
  401020:	ff 35 e2 2f 00 00    	push   0x2fe2(%rip)        # 404008 <_GLOBAL_OFFSET_TABLE_+0x8>
  401026:	ff 25 e4 2f 00 00    	jmp    *0x2fe4(%rip)        # 404010 <_GLOBAL_OFFSET_TABLE_+0x10>
  40102c:	0f 1f 40 00          	nopl   0x0(%rax)

0000000000401030 <_Z8Function27STRUCTstructYjnnzqpnshvtyqe24STRUCTstructXiodevawibeqPhePyde@plt>:
  401030:	ff 25 e2 2f 00 00    	jmp    *0x2fe2(%rip)        # 404018 <_Z8Function27STRUCTstructYjnnzqpnshvtyqe24STRUCTstructXiodevawibeqPhePyde>
  401036:	68 00 00 00 00       	push   $0x0
  40103b:	e9 e0 ff ff ff       	jmp    401020 <_init+0x20>

0000000000401040 <__cxa_atexit@plt>:
  401040:	ff 25 da 2f 00 00    	jmp    *0x2fda(%rip)        # 404020 <__cxa_atexit@GLIBC_2.2.5>
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

0000000000401070 <_GLOBAL__sub_I_main.c>:
  401070:	50                   	push   %rax
  401071:	bf 49 40 40 00       	mov    $0x404049,%edi
  401076:	e8 d5 ff ff ff       	call   401050 <_ZNSt8ios_base4InitC1Ev@plt>
  40107b:	bf 60 10 40 00       	mov    $0x401060,%edi
  401080:	be 49 40 40 00       	mov    $0x404049,%esi
  401085:	ba 40 40 40 00       	mov    $0x404040,%edx
  40108a:	58                   	pop    %rax
  40108b:	e9 b0 ff ff ff       	jmp    401040 <__cxa_atexit@plt>

0000000000401090 <_start>:
  401090:	f3 0f 1e fa          	endbr64 
  401094:	31 ed                	xor    %ebp,%ebp
  401096:	49 89 d1             	mov    %rdx,%r9
  401099:	5e                   	pop    %rsi
  40109a:	48 89 e2             	mov    %rsp,%rdx
  40109d:	48 83 e4 f0          	and    $0xfffffffffffffff0,%rsp
  4010a1:	50                   	push   %rax
  4010a2:	54                   	push   %rsp
  4010a3:	49 c7 c0 f0 12 40 00 	mov    $0x4012f0,%r8
  4010aa:	48 c7 c1 80 12 40 00 	mov    $0x401280,%rcx
  4010b1:	48 c7 c7 80 11 40 00 	mov    $0x401180,%rdi
  4010b8:	ff 15 32 2f 00 00    	call   *0x2f32(%rip)        # 403ff0 <__libc_start_main@GLIBC_2.2.5>
  4010be:	f4                   	hlt    
  4010bf:	90                   	nop

00000000004010c0 <_dl_relocate_static_pie>:
  4010c0:	f3 0f 1e fa          	endbr64 
  4010c4:	c3                   	ret    
  4010c5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  4010cc:	00 00 00 
  4010cf:	90                   	nop

00000000004010d0 <deregister_tm_clones>:
  4010d0:	b8 48 40 40 00       	mov    $0x404048,%eax
  4010d5:	48 3d 48 40 40 00    	cmp    $0x404048,%rax
  4010db:	74 13                	je     4010f0 <deregister_tm_clones+0x20>
  4010dd:	b8 00 00 00 00       	mov    $0x0,%eax
  4010e2:	48 85 c0             	test   %rax,%rax
  4010e5:	74 09                	je     4010f0 <deregister_tm_clones+0x20>
  4010e7:	bf 48 40 40 00       	mov    $0x404048,%edi
  4010ec:	ff e0                	jmp    *%rax
  4010ee:	66 90                	xchg   %ax,%ax
  4010f0:	c3                   	ret    
  4010f1:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
  4010f8:	00 00 00 00 
  4010fc:	0f 1f 40 00          	nopl   0x0(%rax)

0000000000401100 <register_tm_clones>:
  401100:	be 48 40 40 00       	mov    $0x404048,%esi
  401105:	48 81 ee 48 40 40 00 	sub    $0x404048,%rsi
  40110c:	48 89 f0             	mov    %rsi,%rax
  40110f:	48 c1 ee 3f          	shr    $0x3f,%rsi
  401113:	48 c1 f8 03          	sar    $0x3,%rax
  401117:	48 01 c6             	add    %rax,%rsi
  40111a:	48 d1 fe             	sar    %rsi
  40111d:	74 11                	je     401130 <register_tm_clones+0x30>
  40111f:	b8 00 00 00 00       	mov    $0x0,%eax
  401124:	48 85 c0             	test   %rax,%rax
  401127:	74 07                	je     401130 <register_tm_clones+0x30>
  401129:	bf 48 40 40 00       	mov    $0x404048,%edi
  40112e:	ff e0                	jmp    *%rax
  401130:	c3                   	ret    
  401131:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
  401138:	00 00 00 00 
  40113c:	0f 1f 40 00          	nopl   0x0(%rax)

0000000000401140 <__do_global_dtors_aux>:
  401140:	f3 0f 1e fa          	endbr64 
  401144:	80 3d fd 2e 00 00 00 	cmpb   $0x0,0x2efd(%rip)        # 404048 <__TMC_END__>
  40114b:	75 13                	jne    401160 <__do_global_dtors_aux+0x20>
  40114d:	55                   	push   %rbp
  40114e:	48 89 e5             	mov    %rsp,%rbp
  401151:	e8 7a ff ff ff       	call   4010d0 <deregister_tm_clones>
  401156:	c6 05 eb 2e 00 00 01 	movb   $0x1,0x2eeb(%rip)        # 404048 <__TMC_END__>
  40115d:	5d                   	pop    %rbp
  40115e:	c3                   	ret    
  40115f:	90                   	nop
  401160:	c3                   	ret    
  401161:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
  401168:	00 00 00 00 
  40116c:	0f 1f 40 00          	nopl   0x0(%rax)

0000000000401170 <frame_dummy>:
  401170:	f3 0f 1e fa          	endbr64 
  401174:	eb 8a                	jmp    401100 <register_tm_clones>
  401176:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  40117d:	00 00 00 

0000000000401180 <main>:
  401180:	48 81 ec d8 00 00 00 	sub    $0xd8,%rsp
  401187:	c6 44 24 77 62       	movb   $0x62,0x77(%rsp)
  40118c:	48 b8 89 e4 e1 86 51 	movabs $0x585186e1e489,%rax
  401193:	58 00 00 
  401196:	48 89 44 24 78       	mov    %rax,0x78(%rsp)
  40119b:	c7 84 24 80 00 00 00 	movl   $0x4152dfa1,0x80(%rsp)
  4011a2:	a1 df 52 41 
  4011a6:	c6 84 24 84 00 00 00 	movb   $0x6e,0x84(%rsp)
  4011ad:	6e 
  4011ae:	48 c7 84 24 88 00 00 	movq   $0x894b,0x88(%rsp)
  4011b5:	00 4b 89 00 00 
  4011ba:	0f 28 05 4f 0e 00 00 	movaps 0xe4f(%rip),%xmm0        # 402010 <_IO_stdin_used+0x10>
  4011c1:	0f 11 84 24 90 00 00 	movups %xmm0,0x90(%rsp)
  4011c8:	00 
  4011c9:	48 b8 76 a5 d5 a1 a2 	movabs $0x7b79d4a2a1d5a576,%rax
  4011d0:	d4 79 7b 
  4011d3:	48 89 84 24 a0 00 00 	mov    %rax,0xa0(%rsp)
  4011da:	00 
  4011db:	66 c7 84 24 a8 00 00 	movw   $0x9b5c,0xa8(%rsp)
  4011e2:	00 5c 9b 
  4011e5:	dd 05 35 0e 00 00    	fldl   0xe35(%rip)        # 402020 <_IO_stdin_used+0x20>
  4011eb:	db bc 24 b0 00 00 00 	fstpt  0xb0(%rsp)
  4011f2:	48 b8 8a c1 24 55 05 	movabs $0x502f8b055524c18a,%rax
  4011f9:	8b 2f 50 
  4011fc:	48 89 84 24 c0 00 00 	mov    %rax,0xc0(%rsp)
  401203:	00 
  401204:	0f 28 84 24 a0 00 00 	movaps 0xa0(%rsp),%xmm0
  40120b:	00 
  40120c:	0f 28 8c 24 b0 00 00 	movaps 0xb0(%rsp),%xmm1
  401213:	00 
  401214:	0f 28 94 24 c0 00 00 	movaps 0xc0(%rsp),%xmm2
  40121b:	00 
  40121c:	0f 29 54 24 40       	movaps %xmm2,0x40(%rsp)
  401221:	0f 29 4c 24 30       	movaps %xmm1,0x30(%rsp)
  401226:	0f 29 44 24 20       	movaps %xmm0,0x20(%rsp)
  40122b:	0f 10 84 24 80 00 00 	movups 0x80(%rsp),%xmm0
  401232:	00 
  401233:	0f 10 8c 24 90 00 00 	movups 0x90(%rsp),%xmm1
  40123a:	00 
  40123b:	0f 11 4c 24 10       	movups %xmm1,0x10(%rsp)
  401240:	0f 11 04 24          	movups %xmm0,(%rsp)
  401244:	dd 05 de 0d 00 00    	fldl   0xdde(%rip)        # 402028 <_IO_stdin_used+0x28>
  40124a:	db 7c 24 60          	fstpt  0x60(%rsp)
  40124e:	dd 05 dc 0d 00 00    	fldl   0xddc(%rip)        # 402030 <_IO_stdin_used+0x30>
  401254:	db 7c 24 50          	fstpt  0x50(%rsp)
  401258:	48 8d 7c 24 77       	lea    0x77(%rsp),%rdi
  40125d:	48 8d 74 24 78       	lea    0x78(%rsp),%rsi
  401262:	f2 0f 10 05 ce 0d 00 	movsd  0xdce(%rip),%xmm0        # 402038 <_IO_stdin_used+0x38>
  401269:	00 
  40126a:	e8 c1 fd ff ff       	call   401030 <_Z8Function27STRUCTstructYjnnzqpnshvtyqe24STRUCTstructXiodevawibeqPhePyde@plt>
  40126f:	31 c0                	xor    %eax,%eax
  401271:	48 81 c4 d8 00 00 00 	add    $0xd8,%rsp
  401278:	c3                   	ret    
  401279:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)

0000000000401280 <__libc_csu_init>:
  401280:	f3 0f 1e fa          	endbr64 
  401284:	41 57                	push   %r15
  401286:	4c 8d 3d 2b 2b 00 00 	lea    0x2b2b(%rip),%r15        # 403db8 <__frame_dummy_init_array_entry>
  40128d:	41 56                	push   %r14
  40128f:	49 89 d6             	mov    %rdx,%r14
  401292:	41 55                	push   %r13
  401294:	49 89 f5             	mov    %rsi,%r13
  401297:	41 54                	push   %r12
  401299:	41 89 fc             	mov    %edi,%r12d
  40129c:	55                   	push   %rbp
  40129d:	48 8d 2d 24 2b 00 00 	lea    0x2b24(%rip),%rbp        # 403dc8 <__do_global_dtors_aux_fini_array_entry>
  4012a4:	53                   	push   %rbx
  4012a5:	4c 29 fd             	sub    %r15,%rbp
  4012a8:	48 83 ec 08          	sub    $0x8,%rsp
  4012ac:	e8 4f fd ff ff       	call   401000 <_init>
  4012b1:	48 c1 fd 03          	sar    $0x3,%rbp
  4012b5:	74 1f                	je     4012d6 <__libc_csu_init+0x56>
  4012b7:	31 db                	xor    %ebx,%ebx
  4012b9:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  4012c0:	4c 89 f2             	mov    %r14,%rdx
  4012c3:	4c 89 ee             	mov    %r13,%rsi
  4012c6:	44 89 e7             	mov    %r12d,%edi
  4012c9:	41 ff 14 df          	call   *(%r15,%rbx,8)
  4012cd:	48 83 c3 01          	add    $0x1,%rbx
  4012d1:	48 39 dd             	cmp    %rbx,%rbp
  4012d4:	75 ea                	jne    4012c0 <__libc_csu_init+0x40>
  4012d6:	48 83 c4 08          	add    $0x8,%rsp
  4012da:	5b                   	pop    %rbx
  4012db:	5d                   	pop    %rbp
  4012dc:	41 5c                	pop    %r12
  4012de:	41 5d                	pop    %r13
  4012e0:	41 5e                	pop    %r14
  4012e2:	41 5f                	pop    %r15
  4012e4:	c3                   	ret    
  4012e5:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
  4012ec:	00 00 00 00 

00000000004012f0 <__libc_csu_fini>:
  4012f0:	f3 0f 1e fa          	endbr64 
  4012f4:	c3                   	ret    

Disassembly of section .fini:

00000000004012f8 <_fini>:
  4012f8:	f3 0f 1e fa          	endbr64 
  4012fc:	48 83 ec 08          	sub    $0x8,%rsp
  401300:	48 83 c4 08          	add    $0x8,%rsp
  401304:	c3                   	ret 
```

## Without Fix

```bash
clang++ -fPIC -shared -O3 -g -Wdeprecated -o libfoo.so foo.c
clang-14: warning: treating 'c' input as 'c++' when in C++ mode, this behavior is deprecated [-Wdeprecated]
Aggregate size: 256 Lo: 7 Hi: 6triggered by second to last
Final state Lo: 7 Hi: 6
Aggregate size: 384 Lo: 7 Hi: 6triggered by second to last
Final state Lo: 7 Hi: 6

clang++ -O3 -o v main.c -L. -lfoo -Wl,-rpath,`pwd`
clang-14: warning: treating 'c' input as 'c++' when in C++ mode, this behavior is deprecated [-Wdeprecated]
Aggregate size: 256 Lo: 7 Hi: 6triggered by second to last
Final state Lo: 7 Hi: 6
Aggregate size: 384 Lo: 7 Hi: 6triggered by second to last
Final state Lo: 7 Hi: 6
```

From the print out we see that the final state is different - for the fix both are put into enum 7 (MEMORY)
and without it's put into enum 7 and enum 6 (MEMORY and NO CLASS).

### Assembly
