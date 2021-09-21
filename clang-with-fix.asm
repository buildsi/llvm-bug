
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

0000000000001020 <printf@plt-0x10>:
    1020:	ff 35 e2 2f 00 00    	push   0x2fe2(%rip)        # 4008 <_GLOBAL_OFFSET_TABLE_+0x8>
    1026:	ff 25 e4 2f 00 00    	jmp    *0x2fe4(%rip)        # 4010 <_GLOBAL_OFFSET_TABLE_+0x10>
    102c:	0f 1f 40 00          	nopl   0x0(%rax)

0000000000001030 <printf@plt>:
    1030:	ff 25 e2 2f 00 00    	jmp    *0x2fe2(%rip)        # 4018 <printf@GLIBC_2.2.5>
    1036:	68 00 00 00 00       	push   $0x0
    103b:	e9 e0 ff ff ff       	jmp    1020 <_init+0x20>

Disassembly of section .plt.got:

0000000000001040 <__cxa_finalize@plt>:
    1040:	ff 25 b2 2f 00 00    	jmp    *0x2fb2(%rip)        # 3ff8 <__cxa_finalize@GLIBC_2.2.5>
    1046:	66 90                	xchg   %ax,%ax

Disassembly of section .text:

0000000000001050 <deregister_tm_clones>:
    1050:	48 8d 3d d1 2f 00 00 	lea    0x2fd1(%rip),%rdi        # 4028 <completed.0>
    1057:	48 8d 05 ca 2f 00 00 	lea    0x2fca(%rip),%rax        # 4028 <completed.0>
    105e:	48 39 f8             	cmp    %rdi,%rax
    1061:	74 15                	je     1078 <deregister_tm_clones+0x28>
    1063:	48 8b 05 76 2f 00 00 	mov    0x2f76(%rip),%rax        # 3fe0 <_ITM_deregisterTMCloneTable>
    106a:	48 85 c0             	test   %rax,%rax
    106d:	74 09                	je     1078 <deregister_tm_clones+0x28>
    106f:	ff e0                	jmp    *%rax
    1071:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
    1078:	c3                   	ret    
    1079:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)

0000000000001080 <register_tm_clones>:
    1080:	48 8d 3d a1 2f 00 00 	lea    0x2fa1(%rip),%rdi        # 4028 <completed.0>
    1087:	48 8d 35 9a 2f 00 00 	lea    0x2f9a(%rip),%rsi        # 4028 <completed.0>
    108e:	48 29 fe             	sub    %rdi,%rsi
    1091:	48 89 f0             	mov    %rsi,%rax
    1094:	48 c1 ee 3f          	shr    $0x3f,%rsi
    1098:	48 c1 f8 03          	sar    $0x3,%rax
    109c:	48 01 c6             	add    %rax,%rsi
    109f:	48 d1 fe             	sar    %rsi
    10a2:	74 14                	je     10b8 <register_tm_clones+0x38>
    10a4:	48 8b 05 45 2f 00 00 	mov    0x2f45(%rip),%rax        # 3ff0 <_ITM_registerTMCloneTable>
    10ab:	48 85 c0             	test   %rax,%rax
    10ae:	74 08                	je     10b8 <register_tm_clones+0x38>
    10b0:	ff e0                	jmp    *%rax
    10b2:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
    10b8:	c3                   	ret    
    10b9:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)

00000000000010c0 <__do_global_dtors_aux>:
    10c0:	f3 0f 1e fa          	endbr64 
    10c4:	80 3d 5d 2f 00 00 00 	cmpb   $0x0,0x2f5d(%rip)        # 4028 <completed.0>
    10cb:	75 2b                	jne    10f8 <__do_global_dtors_aux+0x38>
    10cd:	55                   	push   %rbp
    10ce:	48 83 3d 22 2f 00 00 	cmpq   $0x0,0x2f22(%rip)        # 3ff8 <__cxa_finalize@GLIBC_2.2.5>
    10d5:	00 
    10d6:	48 89 e5             	mov    %rsp,%rbp
    10d9:	74 0c                	je     10e7 <__do_global_dtors_aux+0x27>
    10db:	48 8b 3d 3e 2f 00 00 	mov    0x2f3e(%rip),%rdi        # 4020 <__dso_handle>
    10e2:	e8 59 ff ff ff       	call   1040 <__cxa_finalize@plt>
    10e7:	e8 64 ff ff ff       	call   1050 <deregister_tm_clones>
    10ec:	c6 05 35 2f 00 00 01 	movb   $0x1,0x2f35(%rip)        # 4028 <completed.0>
    10f3:	5d                   	pop    %rbp
    10f4:	c3                   	ret    
    10f5:	0f 1f 00             	nopl   (%rax)
    10f8:	c3                   	ret    
    10f9:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)

0000000000001100 <frame_dummy>:
    1100:	f3 0f 1e fa          	endbr64 
    1104:	e9 77 ff ff ff       	jmp    1080 <register_tm_clones>
    1109:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)

0000000000001110 <bigcall>:
    1110:	50                   	push   %rax
    1111:	4d 89 ca             	mov    %r9,%r10
    1114:	4d 89 c1             	mov    %r8,%r9
    1117:	49 89 c8             	mov    %rcx,%r8
    111a:	48 89 d1             	mov    %rdx,%rcx
    111d:	48 89 f2             	mov    %rsi,%rdx
    1120:	48 89 fe             	mov    %rdi,%rsi
    1123:	48 8d 3d d6 0e 00 00 	lea    0xed6(%rip),%rdi        # 2000 <_fini+0xec0>
    112a:	31 c0                	xor    %eax,%eax
    112c:	41 52                	push   %r10
    112e:	ff 74 24 18          	push   0x18(%rsp)
    1132:	e8 f9 fe ff ff       	call   1030 <printf@plt>
    1137:	48 83 c4 10          	add    $0x10,%rsp
    113b:	58                   	pop    %rax
    113c:	c3                   	ret    

Disassembly of section .fini:

0000000000001140 <_fini>:
    1140:	f3 0f 1e fa          	endbr64 
    1144:	48 83 ec 08          	sub    $0x8,%rsp
    1148:	48 83 c4 08          	add    $0x8,%rsp
    114c:	c3                   	ret    
