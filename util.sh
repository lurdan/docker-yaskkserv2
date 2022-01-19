#!/bin/bash

PREFIX=${PREFIX:-/usr/local/bin}

_clean() {
  rm -rf yaskkserv2
  rm dictionary.yaskkserv2
}

_build() {
  local TAG="${1:-lurdan/yaskkserv2}"

  git clone https://github.com/wachikun/yaskkserv2

  if [ -e "${HOME}/.docker/cli-plugins/docker-buildx" ];
  then
    docker run -it --rm --privileged tonistiigi/binfmt --install all
    docker buildx build --platform linux/arm/v7,linux/arm64,linux/amd64 -t ${TAG} --push .
  else
    docker build -t ${TAG} .
  fi
}

_dic() {
  local DICS="$*"
  local DIC_FILES

  [ -e $PREFIX/yaskkserv2_make_dictionary ] || PREFIX="docker run -it --rm -v $PWD:/data lurdan/yaskkserv2 /usr/local/bin/"

  for DIC in $DICS
  do
    [ -f SKK-JISYO.${DIC} ] || ( wget -q https://github.com/skk-dev/dict/raw/gh-pages/SKK-JISYO.${DIC}.gz && gunzip SKK-JISYO.${DIC}.gz )
    DIC_FILES="$DIC_FILES SKK-JISYO.${DIC}"
  done
  ${PREFIX}/yaskkserv2_make_dictionary --dictionary-filename=dictionary.yaskkserv2 ${DIC_FILES}
}

_$*
