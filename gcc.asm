
libtest.so:     file format elf64-x86-64


Disassembly of section .init:

0000000000001000 <_init>:
    1000:	f3 0f 1e fa          	endbr64 
    1004:	48 83 ec 08          	sub    $0x8,%rsp
    1008:	48 8b 05 d9 2f 00 00 	mov    0x2fd9(%rip),%rax        # 3fe8 <__gmon_start__>
    100f:	48 85 c0             	test   %rax,%rax
    1012:	74 02                	je     1016 <_init+0x16>
    1014:	ff d0                	call   *%rax
    1016:	48 83 c4 08          	add    $0x8,%rsp
    101a:	c3                   	ret    

Disassembly of section .plt:

0000000000001020 <.plt>:
    1020:	ff 35 e2 2f 00 00    	push   0x2fe2(%rip)        # 4008 <_GLOBAL_OFFSET_TABLE_+0x8>
    1026:	f2 ff 25 e3 2f 00 00 	bnd jmp *0x2fe3(%rip)        # 4010 <_GLOBAL_OFFSET_TABLE_+0x10>
    102d:	0f 1f 00             	nopl   (%rax)
    1030:	f3 0f 1e fa          	endbr64 
    1034:	68 00 00 00 00       	push   $0x0
    1039:	f2 e9 e1 ff ff ff    	bnd jmp 1020 <_init+0x20>
    103f:	90                   	nop

Disassembly of section .plt.got:

0000000000001040 <__cxa_finalize@plt>:
    1040:	f3 0f 1e fa          	endbr64 
    1044:	f2 ff 25 ad 2f 00 00 	bnd jmp *0x2fad(%rip)        # 3ff8 <__cxa_finalize@GLIBC_2.2.5>
    104b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)

Disassembly of section .plt.sec:

0000000000001050 <__printf_chk@plt>:
    1050:	f3 0f 1e fa          	endbr64 
    1054:	f2 ff 25 bd 2f 00 00 	bnd jmp *0x2fbd(%rip)        # 4018 <__printf_chk@GLIBC_2.3.4>
    105b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)

Disassembly of section .text:

0000000000001060 <deregister_tm_clones>:
    1060:	48 8d 3d c1 2f 00 00 	lea    0x2fc1(%rip),%rdi        # 4028 <completed.0>
    1067:	48 8d 05 ba 2f 00 00 	lea    0x2fba(%rip),%rax        # 4028 <completed.0>
    106e:	48 39 f8             	cmp    %rdi,%rax
    1071:	74 15                	je     1088 <deregister_tm_clones+0x28>
    1073:	48 8b 05 66 2f 00 00 	mov    0x2f66(%rip),%rax        # 3fe0 <_ITM_deregisterTMCloneTable>
    107a:	48 85 c0             	test   %rax,%rax
    107d:	74 09                	je     1088 <deregister_tm_clones+0x28>
    107f:	ff e0                	jmp    *%rax
    1081:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
    1088:	c3                   	ret    
    1089:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)

0000000000001090 <register_tm_clones>:
    1090:	48 8d 3d 91 2f 00 00 	lea    0x2f91(%rip),%rdi        # 4028 <completed.0>
    1097:	48 8d 35 8a 2f 00 00 	lea    0x2f8a(%rip),%rsi        # 4028 <completed.0>
    109e:	48 29 fe             	sub    %rdi,%rsi
    10a1:	48 89 f0             	mov    %rsi,%rax
    10a4:	48 c1 ee 3f          	shr    $0x3f,%rsi
    10a8:	48 c1 f8 03          	sar    $0x3,%rax
    10ac:	48 01 c6             	add    %rax,%rsi
    10af:	48 d1 fe             	sar    %rsi
    10b2:	74 14                	je     10c8 <register_tm_clones+0x38>
    10b4:	48 8b 05 35 2f 00 00 	mov    0x2f35(%rip),%rax        # 3ff0 <_ITM_registerTMCloneTable>
    10bb:	48 85 c0             	test   %rax,%rax
    10be:	74 08                	je     10c8 <register_tm_clones+0x38>
    10c0:	ff e0                	jmp    *%rax
    10c2:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
    10c8:	c3                   	ret    
    10c9:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)

00000000000010d0 <__do_global_dtors_aux>:
    10d0:	f3 0f 1e fa          	endbr64 
    10d4:	80 3d 4d 2f 00 00 00 	cmpb   $0x0,0x2f4d(%rip)        # 4028 <completed.0>
    10db:	75 2b                	jne    1108 <__do_global_dtors_aux+0x38>
    10dd:	55                   	push   %rbp
    10de:	48 83 3d 12 2f 00 00 	cmpq   $0x0,0x2f12(%rip)        # 3ff8 <__cxa_finalize@GLIBC_2.2.5>
    10e5:	00 
    10e6:	48 89 e5             	mov    %rsp,%rbp
    10e9:	74 0c                	je     10f7 <__do_global_dtors_aux+0x27>
    10eb:	48 8b 3d 2e 2f 00 00 	mov    0x2f2e(%rip),%rdi        # 4020 <__dso_handle>
    10f2:	e8 49 ff ff ff       	call   1040 <__cxa_finalize@plt>
    10f7:	e8 64 ff ff ff       	call   1060 <deregister_tm_clones>
    10fc:	c6 05 25 2f 00 00 01 	movb   $0x1,0x2f25(%rip)        # 4028 <completed.0>
    1103:	5d                   	pop    %rbp
    1104:	c3                   	ret    
    1105:	0f 1f 00             	nopl   (%rax)
    1108:	c3                   	ret    
    1109:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)

0000000000001110 <frame_dummy>:
    1110:	f3 0f 1e fa          	endbr64 
    1114:	e9 77 ff ff ff       	jmp    1090 <register_tm_clones>
    1119:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)

0000000000001120 <bigcall>:
    1120:	f3 0f 1e fa          	endbr64 
    1124:	48 83 ec 10          	sub    $0x10,%rsp
    1128:	49 89 c9             	mov    %rcx,%r9
    112b:	31 c0                	xor    %eax,%eax
    112d:	48 89 f1             	mov    %rsi,%rcx
    1130:	ff 74 24 18          	push   0x18(%rsp)
    1134:	48 8d 35 c5 0e 00 00 	lea    0xec5(%rip),%rsi        # 2000 <_fini+0xea8>
    113b:	ff 74 24 28          	push   0x28(%rsp)
    113f:	41 50                	push   %r8
    1141:	49 89 d0             	mov    %rdx,%r8
    1144:	48 89 fa             	mov    %rdi,%rdx
    1147:	bf 01 00 00 00       	mov    $0x1,%edi
    114c:	e8 ff fe ff ff       	call   1050 <__printf_chk@plt>
    1151:	48 83 c4 28          	add    $0x28,%rsp
    1155:	c3                   	ret    

Disassembly of section .fini:

0000000000001158 <_fini>:
    1158:	f3 0f 1e fa          	endbr64 
    115c:	48 83 ec 08          	sub    $0x8,%rsp
    1160:	48 83 c4 08          	add    $0x8,%rsp
    1164:	c3                   	ret    
