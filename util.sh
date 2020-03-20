#!/bin/sh

_clean() {
  rm -rf yaskkserv2
  rm dictionary.yaskkserv2
}

_build() {
  local TAG="${1:-lurdan/yaskkserv2}"

  git clone https://github.com/wachikun/yaskkserv2
  docker build -t ${TAG} .
}

_dic() {
  local DICS="$*"
  local DIC_FILES

  for DIC in $DICS
  do
    [ -f SKK-JISYO.${DIC} ] || ( wget -q https://github.com/skk-dev/dict/raw/gh-pages/SKK-JISYO.${DIC}.gz && gunzip SKK-JISYO.${DIC}.gz )
    DIC_FILES="$DIC_FILES SKK-JISYO.${DIC}"
  done
  docker run -it --rm -v $PWD:/data lurdan/yaskkserv2 /usr/local/bin/yaskkserv2_make_dictionary --dictionary-filename=dictionary.yaskkserv2 ${DIC_FILES}
}

_$*
