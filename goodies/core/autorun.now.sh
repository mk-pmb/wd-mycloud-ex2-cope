#!/bin/bash
# -*- coding: utf-8, tab-width: 2 -*-


function goodies_autorun_now () {
  export LANG{,UAGE}=en_US.UTF-8  # make error messages search engine-friendly
  local SELF_ABS="$(readlink -f -- "$BASH_SOURCE")" # busybox
  local SELF_DIR="${SELF_ABS%/*}"
  local COPE_DIR="${SELF_DIR%/*/*}"
  cd -- "$COPE_DIR" || return $?
  exec </dev/null
  local VAL='/etc/profile'
  [ ! -f "$VAL" ] || source -- "$VAL"

  export COPE_DIR
  for VAL in $( ./goodies/core/find_config_files.sh autorun ); do
    [ -f "$VAL" ] || continue
    [ -x "$VAL" ] || continue
    echo "==== $VAL ===="
    ./"$VAL" || echo W: "^-- exit code $? from $VAL" >&2
    echo
  done
  echo "==== Done. ===="
}










goodies_autorun_now "$@"; exit $?
