# git-config
Git configuration for chia33164

## pre-commit.sh
The hook is trigged by the command `git commit`.
When you trig `commit`, the hook will automatically do spell checking (GNU Aspell), coding style checking (clang-format), static analysis (cppcheck), and unsafe functions removal (e.g. gets, sprintf, strcpy).

## commit-msg.sh
The hook is trigged after finishing editing a commit message, and it will automatically check whether the commit is a good commit.
Based on [git-good-commit](https://github.com/tommarshall/git-good-commit), I extend a function to do spell checking with GNU Aspell in order to avoid missing spelling.
