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
  echo D: "source $VAL"
  [ ! -f "$VAL" ] || source -- "$VAL"
  echo D: "done sourcing $VAL"
  local CORE_SUB="${SELF_DIR:${#COPE_DIR}}"
  CORE_SUB="${CORE_SUB#/}"
  local -p
  local TODO=(
    find
    @*/autorun/
    "$CORE_SUB"
    -maxdepth 1
    '(' -type f -o -type l ')'
    -name '[0-9][0-9]*' # accept a minimum of 2 digits for compatibility.
    -printf '%f\t%p\n'
    )
  TODO=( $( "${TODO[@]}" | sort -V | cut -sf 2- ) )
  export COPE_DIR
  for VAL in "${TODO[@]}"; do
    echo "==== $VAL ===="
    "$VAL" || echo W: "^-- exit code $? from $VAL" >&2
    echo
  done
  echo "==== Done. ===="
}










goodies_autorun_now "$@"; exit $?
