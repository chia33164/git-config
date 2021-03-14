# git-config
Git configuration for chia33164

## Installation
### Single repository
Move to the root of the repository, and then copy the files in `git-config/hooks/` to the repository:
```
$ cd <target repository>/
$ cp <path to git-config>/hooks/commit-msg .git/hooks/ && chmod +x .git/hooks/commit-msg
$ cp <path to git-config>/hooks/pre-commit .git/hooks/ && chmod +x .git/hooks/pre-commit
```

### Globally
Setup the hooks when you type `git init` in the repository.
```
$ mkdir -p ~/.git-templates
$ git config --global init.templatedir '~/.git-templates'
$ cp -r <path to git-config>/hooks ~/.git-templates/
$ cd <target repository> && git init
```
You can [safely run](https://stackoverflow.com/questions/5149694/does-running-git-init-twice-initialize-a-repository-or-reinitialize-an-existing/5149861#5149861) `git init` in the repository with `.git` directory.

## Hook Description
### pre-commit
The hook is trigged by the command `git commit`.
When you trig `commit`, the hook will automatically do spell checking (GNU Aspell), coding style checking (clang-format), static analysis (cppcheck), and unsafe functions removal (e.g. gets, sprintf, strcpy).

### commit-msg
The hook is trigged after finishing editing a commit message, and it will automatically check whether the commit is a good commit.
Based on [git-good-commit](https://github.com/tommarshall/git-good-commit), I extend a function to do spell checking with GNU Aspell in order to avoid missing spelling.
