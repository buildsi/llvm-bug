
libfoo-fix.so:     file format elf64-x86-64


Disassembly of section .init:

0000000000001000 <_init>:
    1000:	f3 0f 1e fa          	endbr64 
    1004:	48 83 ec 08          	sub    $0x8,%rsp
    1008:	48 8b 05 d9 2f 00 00 	mov    0x2fd9(%rip),%rax        # 3fe8 <__gmon_start__>
    100f:	48 85 c0             	test   %rax,%rax
    1012:	74 02                	je     1016 <_init+0x16>
    1014:	ff d0                	callq  *%rax
    1016:	48 83 c4 08          	add    $0x8,%rsp
    101a:	c3                   	retq   

Disassembly of section .plt:

0000000000001020 <.plt>:
    1020:	ff 35 e2 2f 00 00    	pushq  0x2fe2(%rip)        # 4008 <_GLOBAL_OFFSET_TABLE_+0x8>
    1026:	ff 25 e4 2f 00 00    	jmpq   *0x2fe4(%rip)        # 4010 <_GLOBAL_OFFSET_TABLE_+0x10>
    102c:	0f 1f 40 00          	nopl   0x0(%rax)

Disassembly of section .plt.got:

0000000000001030 <__cxa_finalize@plt>:
    1030:	ff 25 c2 2f 00 00    	jmpq   *0x2fc2(%rip)        # 3ff8 <__cxa_finalize@GLIBC_2.2.5>
    1036:	66 90                	xchg   %ax,%ax

Disassembly of section .text:

0000000000001040 <deregister_tm_clones>:
    1040:	48 8d 3d d9 2f 00 00 	lea    0x2fd9(%rip),%rdi        # 4020 <completed.0>
    1047:	48 8d 05 d2 2f 00 00 	lea    0x2fd2(%rip),%rax        # 4020 <completed.0>
    104e:	48 39 f8             	cmp    %rdi,%rax
    1051:	74 15                	je     1068 <deregister_tm_clones+0x28>
    1053:	48 8b 05 86 2f 00 00 	mov    0x2f86(%rip),%rax        # 3fe0 <_ITM_deregisterTMCloneTable>
    105a:	48 85 c0             	test   %rax,%rax
    105d:	74 09                	je     1068 <deregister_tm_clones+0x28>
    105f:	ff e0                	jmpq   *%rax
    1061:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
    1068:	c3                   	retq   
    1069:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)

0000000000001070 <register_tm_clones>:
    1070:	48 8d 3d a9 2f 00 00 	lea    0x2fa9(%rip),%rdi        # 4020 <completed.0>
    1077:	48 8d 35 a2 2f 00 00 	lea    0x2fa2(%rip),%rsi        # 4020 <completed.0>
    107e:	48 29 fe             	sub    %rdi,%rsi
    1081:	48 89 f0             	mov    %rsi,%rax
    1084:	48 c1 ee 3f          	shr    $0x3f,%rsi
    1088:	48 c1 f8 03          	sar    $0x3,%rax
    108c:	48 01 c6             	add    %rax,%rsi
    108f:	48 d1 fe             	sar    %rsi
    1092:	74 14                	je     10a8 <register_tm_clones+0x38>
    1094:	48 8b 05 55 2f 00 00 	mov    0x2f55(%rip),%rax        # 3ff0 <_ITM_registerTMCloneTable>
    109b:	48 85 c0             	test   %rax,%rax
    109e:	74 08                	je     10a8 <register_tm_clones+0x38>
    10a0:	ff e0                	jmpq   *%rax
    10a2:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
    10a8:	c3                   	retq   
    10a9:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)

00000000000010b0 <__do_global_dtors_aux>:
    10b0:	f3 0f 1e fa          	endbr64 
    10b4:	80 3d 65 2f 00 00 00 	cmpb   $0x0,0x2f65(%rip)        # 4020 <completed.0>
    10bb:	75 2b                	jne    10e8 <__do_global_dtors_aux+0x38>
    10bd:	55                   	push   %rbp
    10be:	48 83 3d 32 2f 00 00 	cmpq   $0x0,0x2f32(%rip)        # 3ff8 <__cxa_finalize@GLIBC_2.2.5>
    10c5:	00 
    10c6:	48 89 e5             	mov    %rsp,%rbp
    10c9:	74 0c                	je     10d7 <__do_global_dtors_aux+0x27>
    10cb:	48 8b 3d 46 2f 00 00 	mov    0x2f46(%rip),%rdi        # 4018 <__dso_handle>
    10d2:	e8 59 ff ff ff       	callq  1030 <__cxa_finalize@plt>
    10d7:	e8 64 ff ff ff       	callq  1040 <deregister_tm_clones>
    10dc:	c6 05 3d 2f 00 00 01 	movb   $0x1,0x2f3d(%rip)        # 4020 <completed.0>
    10e3:	5d                   	pop    %rbp
    10e4:	c3                   	retq   
    10e5:	0f 1f 00             	nopl   (%rax)
    10e8:	c3                   	retq   
    10e9:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)

00000000000010f0 <frame_dummy>:
    10f0:	f3 0f 1e fa          	endbr64 
    10f4:	e9 77 ff ff ff       	jmpq   1070 <register_tm_clones>
    10f9:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)

0000000000001100 <func>:
    1100:	55                   	push   %rbp
    1101:	48 89 e5             	mov    %rsp,%rbp
    1104:	48 83 e4 c0          	and    $0xffffffffffffffc0,%rsp
    1108:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
    110f:	8b 45 28             	mov    0x28(%rbp),%eax
    1112:	8b 45 20             	mov    0x20(%rbp),%eax
    1115:	db 6d 10             	fldt   0x10(%rbp)
    1118:	48 89 94 24 e0 00 00 	mov    %rdx,0xe0(%rsp)
    111f:	00 
    1120:	89 bc 24 dc 00 00 00 	mov    %edi,0xdc(%rsp)
    1127:	89 b4 24 d8 00 00 00 	mov    %esi,0xd8(%rsp)
    112e:	89 8c 24 d4 00 00 00 	mov    %ecx,0xd4(%rsp)
    1135:	44 89 84 24 d0 00 00 	mov    %r8d,0xd0(%rsp)
    113c:	00 
    113d:	db bc 24 c0 00 00 00 	fstpt  0xc0(%rsp)
    1144:	c5 fb 11 84 24 b8 00 	vmovsd %xmm0,0xb8(%rsp)
    114b:	00 00 
    114d:	c5 fc 29 8c 24 80 00 	vmovaps %ymm1,0x80(%rsp)
    1154:	00 00 
    1156:	62 f1 7c 48 29 54 24 	vmovaps %zmm2,0x40(%rsp)
    115d:	01 
    115e:	c5 fb 11 5c 24 38    	vmovsd %xmm3,0x38(%rsp)
    1164:	44 89 4c 24 34       	mov    %r9d,0x34(%rsp)
    1169:	48 89 ec             	mov    %rbp,%rsp
    116c:	5d                   	pop    %rbp
    116d:	c5 f8 77             	vzeroupper 
    1170:	c3                   	retq   
    1171:	66 66 66 66 66 66 2e 	data16 data16 data16 data16 data16 nopw %cs:0x0(%rax,%rax,1)
    1178:	0f 1f 84 00 00 00 00 
    117f:	00 

0000000000001180 <getint>:
    1180:	55                   	push   %rbp
    1181:	48 89 e5             	mov    %rsp,%rbp
    1184:	b8 07 00 00 00       	mov    $0x7,%eax
    1189:	5d                   	pop    %rbp
    118a:	c3                   	retq   
    118b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)

0000000000001190 <getdouble>:
    1190:	55                   	push   %rbp
    1191:	48 89 e5             	mov    %rsp,%rbp
    1194:	c5 fb 10 05 64 0e 00 	vmovsd 0xe64(%rip),%xmm0        # 2000 <_fini+0xd3c>
    119b:	00 
    119c:	5d                   	pop    %rbp
    119d:	c3                   	retq   
    119e:	66 90                	xchg   %ax,%ax

00000000000011a0 <getlongdouble>:
    11a0:	55                   	push   %rbp
    11a1:	48 89 e5             	mov    %rsp,%rbp
    11a4:	d9 05 5e 0e 00 00    	flds   0xe5e(%rip)        # 2008 <_fini+0xd44>
    11aa:	5d                   	pop    %rbp
    11ab:	c3                   	retq   
    11ac:	0f 1f 40 00          	nopl   0x0(%rax)

00000000000011b0 <getstructparm>:
    11b0:	55                   	push   %rbp
    11b1:	48 89 e5             	mov    %rsp,%rbp
    11b4:	48 8b 05 55 0e 00 00 	mov    0xe55(%rip),%rax        # 2010 <_fini+0xd4c>
    11bb:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    11bf:	48 8b 05 52 0e 00 00 	mov    0xe52(%rip),%rax        # 2018 <_fini+0xd54>
    11c6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    11ca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    11ce:	5d                   	pop    %rbp
    11cf:	c3                   	retq   

00000000000011d0 <getm256>:
    11d0:	55                   	push   %rbp
    11d1:	48 89 e5             	mov    %rsp,%rbp
    11d4:	48 83 e4 e0          	and    $0xffffffffffffffe0,%rsp
    11d8:	48 81 ec 80 00 00 00 	sub    $0x80,%rsp
    11df:	c7 44 24 1c 00 00 e0 	movl   $0x40e00000,0x1c(%rsp)
    11e6:	40 
    11e7:	c5 fa 10 44 24 1c    	vmovss 0x1c(%rsp),%xmm0
    11ed:	c5 fa 11 44 24 6c    	vmovss %xmm0,0x6c(%rsp)
    11f3:	c5 fa 11 44 24 68    	vmovss %xmm0,0x68(%rsp)
    11f9:	c5 fa 11 44 24 64    	vmovss %xmm0,0x64(%rsp)
    11ff:	c5 fa 11 44 24 60    	vmovss %xmm0,0x60(%rsp)
    1205:	c5 fa 11 44 24 5c    	vmovss %xmm0,0x5c(%rsp)
    120b:	c5 fa 11 44 24 58    	vmovss %xmm0,0x58(%rsp)
    1211:	c5 fa 11 44 24 54    	vmovss %xmm0,0x54(%rsp)
    1217:	c5 fa 11 44 24 50    	vmovss %xmm0,0x50(%rsp)
    121d:	c5 fa 10 4c 24 64    	vmovss 0x64(%rsp),%xmm1
    1223:	c5 fa 10 44 24 60    	vmovss 0x60(%rsp),%xmm0
    1229:	c4 e3 79 21 c1 10    	vinsertps $0x10,%xmm1,%xmm0,%xmm0
    122f:	c5 fa 10 4c 24 68    	vmovss 0x68(%rsp),%xmm1
    1235:	c4 e3 79 21 c1 20    	vinsertps $0x20,%xmm1,%xmm0,%xmm0
    123b:	c5 fa 10 4c 24 6c    	vmovss 0x6c(%rsp),%xmm1
    1241:	c4 e3 79 21 c9 30    	vinsertps $0x30,%xmm1,%xmm0,%xmm1
    1247:	c5 fa 10 54 24 54    	vmovss 0x54(%rsp),%xmm2
    124d:	c5 fa 10 44 24 50    	vmovss 0x50(%rsp),%xmm0
    1253:	c4 e3 79 21 c2 10    	vinsertps $0x10,%xmm2,%xmm0,%xmm0
    1259:	c5 fa 10 54 24 58    	vmovss 0x58(%rsp),%xmm2
    125f:	c4 e3 79 21 c2 20    	vinsertps $0x20,%xmm2,%xmm0,%xmm0
    1265:	c5 fa 10 54 24 5c    	vmovss 0x5c(%rsp),%xmm2
    126b:	c4 e3 79 21 d2 30    	vinsertps $0x30,%xmm2,%xmm0,%xmm2
    1271:	c5 f8 28 c2          	vmovaps %xmm2,%xmm0
    1275:	c4 e3 7d 18 c1 01    	vinsertf128 $0x1,%xmm1,%ymm0,%ymm0
    127b:	c5 fc 29 44 24 20    	vmovaps %ymm0,0x20(%rsp)
    1281:	c5 fc 28 44 24 20    	vmovaps 0x20(%rsp),%ymm0
    1287:	48 89 ec             	mov    %rbp,%rsp
    128a:	5d                   	pop    %rbp
    128b:	c3                   	retq   
    128c:	0f 1f 40 00          	nopl   0x0(%rax)

0000000000001290 <getm512>:
    1290:	55                   	push   %rbp
    1291:	48 89 e5             	mov    %rsp,%rbp
    1294:	48 83 e4 c0          	and    $0xffffffffffffffc0,%rsp
    1298:	48 81 ec 80 00 00 00 	sub    $0x80,%rsp
    129f:	c7 44 24 6c 00 00 e0 	movl   $0x40e00000,0x6c(%rsp)
    12a6:	40 
    12a7:	62 f2 7d 48 18 44 24 	vbroadcastss 0x6c(%rsp),%zmm0
    12ae:	1b 
    12af:	62 f1 7c 48 29 04 24 	vmovaps %zmm0,(%rsp)
    12b6:	62 f1 7c 48 28 04 24 	vmovaps (%rsp),%zmm0
    12bd:	48 89 ec             	mov    %rbp,%rsp
    12c0:	5d                   	pop    %rbp
    12c1:	c3                   	retq   

Disassembly of section .fini:

00000000000012c4 <_fini>:
    12c4:	f3 0f 1e fa          	endbr64 
    12c8:	48 83 ec 08          	sub    $0x8,%rsp
    12cc:	48 83 c4 08          	add    $0x8,%rsp
    12d0:	c3                   	retq   
