# Looking for Bugs

This is a small project to look into [this issue](https://lists.llvm.org/pipermail/llvm-dev/2021-September/152695.html)
and see if building two equivalent llvm's, but one with the correct register assignment rules
for the recursive process when classifying lo and hi, produces a compiler that generates
different binaries (I believe it should not if the detail truly does not matter).

- [llvm-project](llvm-project) was cloned around 7am September 16
- [llvm-project-fix](llvm-project-fix) is an identical copy of that, but with a fix for the bug above.

For both, we will build side by side containers.

## Usage

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
