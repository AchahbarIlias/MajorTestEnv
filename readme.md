# Instructions

## Setup: Receiving updates

To be done once: add our project repo as an extra remote called `upstream`.

```bash
# HTTPS OPTION
$ git remote add upstream https://github.com/ucll-internet-programming-major/project_2021.git
# SSH OPTION
$ git remote add upstream git@github.com:ucll-internet-programming-major/project_2021.git
```

To be done at each update:

```bash
$ git pull upstream main --allow-unrelated-histories -X theirs
```

To be notified of updates, register as watcher [here](https://github.com/ucll-internet-programming-major/project_2021).