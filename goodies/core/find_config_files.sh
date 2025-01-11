#!/bin/bash
# -*- coding: utf-8, tab-width: 2 -*-


function find_config_files () {
  if [[ "$1" == */ ]]; then cd -- "$1"; shift; fi
  # ^-- For easier debugging. e.g. ./find_config_files.sh ../../ autorun

  local TOPIC="$1"; shift

  local FIND=(
    find
    -L # follow symlinks
    )
  local VAL=
  for VAL in @"$HOSTNAME"/"$TOPIC"/ goodies/core/"$TOPIC".default/ ; do
    [ -d "$VAL" ] || continue
    FIND+=( "$VAL" )
  done

  FIND+=(
    -mindepth 1
    # ^-- Make no decisions about the CLI arguments themselves.
    #   Especially, don't -prune them for not matching our name restrictions
    #   farther down.

    -maxdepth 3

    -not -name '[A-Za-z0-9]*' -prune ,
    # ^-- Don't dive into hidden directories or ones with strange names.

    '(' -type f -o -type l ')'
    )

  local NUMPFX='[0-9][0-9]' # accept a minimum of 2 digits for compatibility.
  case "$1" in
    .* )  # e.g. ".conf", ".txt", or ".yml .yaml"
      FIND+=( '(' -false )
      for VAL in $1; do
        FIND+=( -o -name "$NUMPFX*$VAL" )
      done
      FIND+=( ')' )
      shift;;
  esac

  FIND+=(
    "$@"
    -printf '%f\t%p\n'
    )
  [ "${DEBUGLEVEL:-0}" -lt 8 ] || echo D: $FUNCNAME: \
    "gonna$(printf -- ' ‹%s›' "${FIND[@]}")" >&2
  "${FIND[@]}" | sort -V | cut -sf 2-; return $?
}










find_config_files "$@"; exit $?
