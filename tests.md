# Breaking ABI

The following test cases will break ABI. First, here are a library
and executable to compile. Here is the executable [test.c](test.c):

```cpp
#include <stdint.h>

extern void bigcall(long a, long b, long c, long d, long e, __int128_t f);

int main(int argc, char *argv[])
{
   __int128_t c;
   c = 0x0000000000000006;
   c = c << 64;
   c += 0x0000000000000007;
   bigcall(1, 2, 3, 4, 5, c);
   return 0;
}
```

And this is the library [testlib.c](testlib.c)

```cpp
#include <stdint.h>
#include <stdio.h>

void bigcall(long a, long b, long c, long d, long e, __int128_t f)
{
   printf("%ld %ld %ld %ld %ld 0x%lx%lx\n", a, b, c, d, e, (unsigned long) (f >> 64), (unsigned long) (f & 0xffffffffffffffff));
}
```

## Testing without Fix

Testing without the fix, we can compare the output for gcc and clang.

```bash
$ docker run -it -v $PWD:/data vanessa/llvm-project:latest bash

# Add compilers to the path
# export PATH=/opt/spack/opt/spack/linux-ubuntu18.04-skylake/gcc-11.0.1/llvm-main-m22s4pslanvkggagt4kz3n4ae7precgl/bin:$PATH
```

Just to know what we are working with:

```bsah
# gcc --version
gcc (Ubuntu 11-20210417-1ubuntu1) 11.0.1 20210417 (experimental) [master revision c1c86ab96c2:b6fb0ccbb48:8ae884c09fbba91e9cec391290ee4a2859e7ff41]
Copyright (C) 2021 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

root@cbff1ddeab83:/code# clang --version
clang version 14.0.0 (https://github.com/llvm/llvm-project 05ea321f716390abda1632cca71dc9441662cf62)
Target: x86_64-unknown-linux-gnu
Thread model: posix
InstalledDir: /opt/software/linux-ubuntu18.04-skylake/gcc-11.0.1/llvm-main-m22s4pslanvkggagt4kz3n4ae7precgl/bin
```

### Case 1: Build both with clang


```bash
$ cd /data

# build library
$ clang -O2 -o libtest.so -Wall -shared -fPIC testlib.c

# build executable
$ clang -O2 -o ./test test.c -L. -ltest -Wl,-rpath,`pwd`
```

Running the library, I think this is the correct print (with 67)

```bash
# ./test 
1 2 3 4 5 0x67
```

Saving to assembly:

```bash
$ objdump -d libtest.so > clang-without-fix.asm
```

### Case 2: Build both with gcc

Now the same, but with gcc!

```bash
$ cd /data

# build library
$ gcc -O2 -o libtest.so -Wall -shared -fPIC testlib.c

# build executable
$ gcc -O2 -o ./test test.c -L. -ltest -Wl,-rpath,`pwd`
```

Running the library, I think this is the correct print (with 67)

```bash
# ./test 
1 2 3 4 5 0x67
```

Saving to assembly:

```bash
$ objdump -d libtest.so > gcc.asm
```

### Case 3: Build lib with clang, executable with gcc

```bash
$ cd /data

# build library
$ clang -O2 -o libtest.so -Wall -shared -fPIC testlib.c

# build executable
$ gcc -O2 -o ./test test.c -L. -ltest -Wl,-rpath,`pwd`
```

Here is the answer:

```bash
# ./test 
1 2 3 4 5 0x77f992c7c3b50
```

(on a colleague's computer maybe with older gcc this segfaulted)

### Case 4: Build with gcc, executable with clang

```bash
$ cd /data

# build library
$ gcc -O2 -o libtest.so -Wall -shared -fPIC testlib.c

# build executable
$ clang -O2 -o ./test test.c -L. -ltest -Wl,-rpath,`pwd`
```

Here is the answer:

```bash
# ./test 
1 2 3 4 5 0x7f71868b25656
```

## Testing with Fix

Now let's do the same procedure with the container with the "fix" to clang.

```bash
$ docker run -it -v $PWD:/data vanessa/llvm-project-fix:latest bash

# Add compilers to the path
# export PATH=/opt/spack/opt/spack/linux-ubuntu18.04-skylake/gcc-11.0.1/llvm-main-m22s4pslanvkggagt4kz3n4ae7precgl/bin:$PATH
```

Another sanity check

```bash
# clang --version
clang version 14.0.0 (https://github.com/llvm/llvm-project 05ea321f716390abda1632cca71dc9441662cf62)
Target: x86_64-unknown-linux-gnu
Thread model: posix
InstalledDir: /opt/spack/opt/spack/linux-ubuntu18.04-skylake/gcc-11.0.1/llvm-main-m22s4pslanvkggagt4kz3n4ae7precgl/bin

root@01dc579f46a0:/code# gcc --version
gcc (Ubuntu 11-20210417-1ubuntu1) 11.0.1 20210417 (experimental) [master revision c1c86ab96c2:b6fb0ccbb48:8ae884c09fbba91e9cec391290ee4a2859e7ff41]
Copyright (C) 2021 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
```

### Case 1: Build both with clang


```bash
$ cd /data

# build library
$ clang -O2 -o libtest.so -Wall -shared -fPIC testlib.c

# build executable
$ clang -O2 -o ./test test.c -L. -ltest -Wl,-rpath,`pwd`
```

Running the library, I think this is the correct print (with 67)

```bash
# ./test 
1 2 3 4 5 0x67
```

Saving to assembly:

```bash
$ objdump -d libtest.so > clang-with-fix.asm
```

### Case 2: Build both with gcc

Now the same, but with gcc!

```bash
$ cd /data

# build library
$ gcc -O2 -o libtest.so -Wall -shared -fPIC testlib.c

# build executable
$ gcc -O2 -o ./test test.c -L. -ltest -Wl,-rpath,`pwd`
```

Running the library, I think this is the correct print (with 67)

```bash
# ./test 
1 2 3 4 5 0x67
```

### Case 3: Build lib with clang, executable with gcc

```bash
$ cd /data

# build library
$ clang -O2 -o libtest.so -Wall -shared -fPIC testlib.c

# build executable
$ gcc -O2 -o ./test test.c -L. -ltest -Wl,-rpath,`pwd`
```

Here is the answer:

```bash
# ./test 
1 2 3 4 5 0x77f319c4f7b50
```

(on a colleague's computer maybe with older gcc this segfaulted)

### Case 4: Build with gcc, executable with clang

```bash
$ cd /data

# build library
$ gcc -O2 -o libtest.so -Wall -shared -fPIC testlib.c

# build executable
$ clang -O2 -o ./test test.c -L. -ltest -Wl,-rpath,`pwd`
```

Here is the answer:

```bash
# ./test 
1 2 3 4 5 0x7f71868b25656
```


## Looking at Assembly

Here is the gcc assembly ([gcc.asm](gcc.asm))

```asm
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
```

And clang:

```asm
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
```

So the fix didn't make a difference, but I think gcc is pushing both to the stack/memory (e.g., two references to %rsp)
and then clang is putting it into a register instead?
