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

## Assembly

Let's look at the assembly - this is for foo-exec (both use the struct that does the post-merge sequence where the differnce arises)

```bash
$ objdump -d foo-exec > foo-exec.asm
$ objdump -d foo-exec > foo-exec-fix.asm
```

There is no difference!

```bash
$ diff foo-exec.asm foo-exec-fix.asm
```
