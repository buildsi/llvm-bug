# Looking for Bugs

This is a small project to look into [this issue](https://lists.llvm.org/pipermail/llvm-dev/2021-September/152695.html)
and see if building two equivalent llvm's, but one with the correct register assignment rules
for the recursive process when classifying lo and hi, produces a compiler that generates
different binaries (I believe it should not if the detail truly does not matter).

- [llvm-project](llvm-project) was cloned around 7am September 16
- [llvm-project-fix](llvm-project-fix) is an identical copy of that, but with a fix for the bug above.

For both, we will build side by side containers.

## Usage

### 1. Build

Build each of the Dockerfile containers, first for LLVM without changes:

```bash
$ docker build -t vanessa/llvm-project .
```

And then with changes (the "fix"):

```bash
$ docker build --build-arg LLVM_DIR=./llvm-project-fix -t vanessa/llvm-project-fix .
```

To make life easier, the two containers are on Docker Hub beceause pulling is faster than
building:

- [vanessa/llvm-project](https://hub.docker.com/r/vanessa/llvm-project)
- [vanessa/llvm-project-fix](https://hub.docker.com/r/vanessa/llvm-project-fix)

### 2. Test

Now we can compile an example script that uses a bunch of types in each container. For each
below, we are going to test this simple script from [build-abi-tests-tim](https://github.com/buildsi/build-abi-test-tim).


```bash
$ docker run -it llvm-project:latest bash

# This is where clang is
$ cd /
$ git clone https://github.com/buildsi/build-abi-test-tim
$ cd build-abi-test-tim
$ export PATH=/opt/software/linux-ubuntu18.04-skylake/gcc-11.0.1/llvm-main-m22s4pslanvkggagt4kz3n4ae7precgl/bin/:$PATH
$ clang -g -fPIC -shared -march=skylake-avx512 -o libfoo.so foo.c
```

And for the fix (the container is a bit different because I installed to spack instead
of /opt/software).

```bash
$ docker run -it vanessa/llvm-project-fix:latest bash
$ export PATH=/opt/spack/opt/spack/linux-ubuntu18.04-skylake/gcc-11.0.1/llvm-main-m22s4pslanvkggagt4kz3n4ae7precgl/bin:$PATH
$ cd /
$ git clone https://github.com/buildsi/build-abi-test-tim
$ cd build-abi-test-tim
$ clang -g -fPIC -shared -march=skylake-avx512 -o libfoo.so foo.c
```

For both, copy the files outside of the container for further inspection.

```bash
$ docker ps # get the id
$ docker cp ddedd8597804:/build-abi-test-tim/libfoo.so libfoo.so
```

### 3. Compare

**under development!** Smeagle is not done yet.

We can then test with (not finished yet) Smeagle

```bash
$ docker run -v $PWD:/data -it ghcr.io/buildsi/smeagle bash
/code/build/standalone/Smeagle -l /data/libfoo.so > libfoo.so.json
/code/build/standalone/Smeagle -l /data/libfoo-fix.so > libfoo-fix.so.json
```
```
$ diff libfoo.so.json libfoo-fix.so.json 
2c2
<  "library": "/data/libfoo.so",
---
>  "library": "/data/libfoo-fix.so",
```

Didn't find any difference, but the library is far from being finished! 
Or test with libabigail (it didn't find differences):

```bash
$ docker run -v $PWD:/code -it ghcr.io/buildsi/libabigail:1.8.2 bash
```

For both it should be bound to /code

```bash
# ls
# cd /code
# ls
README.md  libfoo-fix.so  libfoo.so
```
```
abidiff libfoo.so libfoo-fix.so
```

I'm not sure how to best test if there are differences - I think I probably need
the right case and I don't know what that is.
