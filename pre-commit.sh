#!/usr/bin/env bash

#
# A git hook to help you to do spell checking, coding style, and unsafe functions removal.
#

RETURN=0
#
# Check the coding style is following the clang-format for consistent coding style.
#
check_clang_format() {
  FILES=`git diff --cached --name-only --diff-filter=ACMR | grep -E "\.(c|cpp|cc|h)$"`
  if [ ! -z ${FILES} ]; then
    for FILE in FILES; do
      nf=`git checkout-index --temp $FILE | cut -f 1`
      tempdir=`mktemp -d` || exit 1
      newfile=`mktemp ${tempdir}/${nf}.XXXXXX` || exit 1
      basename=`basename $FILE`

      source="${tempdir}/${basename}"
      mv $nf $source
      cp .clang-format $tempdir
      $CLANG_FORMAT $source > $newfile 2>> /dev/null
      $DIFF -u -p -B --label="modified $FILE" --label="expected coding style" \
        "${source}" "${newfile}"
      r=$?
      rm -fr "${tempdir}"
      if [ $r -ne 0 ]; then
        echo "[!] $FILE does not follow the consistent coding style." >&2
        RETURN=1
      fi
      if [ $RETURN -eq 1 ]; then
        echo "" >&2
        echo "Make sure you indent as the following:" >&2
        echo "  clang-format -i $FILE" >&2
        echo
      fi
    done
  fi
}

#
# Prevent following unsafe functions:
# @gets
# @sprintf
# @strcpy
#
check_unsafe_functions() {
  root=$(git rev-parse --show-toplevel)
  banned="([^f]gets\() | (sprintf\() | (strcpy\()"
  status=0
  FILES=`git diff --cached --name-only | grep -E "\.(c|cc|cpp|h)\$"`
  for FILE in FILES; do
    filepath="${root}/${FILE}"
    output=$(grep -nrE "${banned}" "${filepath}")
    if [ ! -z ${output} ]; then
      echo "Dangerous function detected in ${filepath}"
      echo "${output}"
      echo
      echo "Read 'Common vulnerabilities guide for C programmers' carefully.'"
      echo "    https://security.web.cern.ch/security/recommendations/en/codetools/c.shtml"
      RETURN=1
    fi
  done
}

#
# Do static analysis with cppcheck.
#
#static_analysis() {

#}

#
# It is showtime.
#
while true; do
  # ---------- Check the tools are all installed ----------- #
  # @clang-format for coding style checking
  # @cppcheck     for static analysis
  # @aspell       for spell checking
  # @colordiff    for

  CLANG_FORMAT=$(which clang-format)
  if [ $? -ne 0 ]; then
    echo "[!] clang-format is not installed. Unable to check source file format policy." >&2
    exit 1
  fi

  CPP_CHECK=$(which cppcheck)
  if [ $? -ne 0 ]; then
    echo "[!] cppcheck is not installed. Unable to perform static analysis." >&2
    exit 1
  fi

  ASPELL=$(which aspell)
  if [ $? -ne 0 ]; then
    echo "[!] GNU Aspell is not installed. Unable to do spell checking." >&2
    exit 1
  fi

  DIFF=$(which colordiff)
  if [ $? -ne 0 ]; then
    echo "[!] colordiff is not installed. Unable to use 'diff' with colour schemes." >&2
    DIFF=diff
  fi

  check_clang_format

  check_unsafe_functions

 # static_analysis

  exit $RETURN
done

