#!/bin/bash
# -*- coding: utf-8, tab-width: 2 -*-


function autosetup () {
  export LANG{,UAGE}=en_US.UTF-8  # make error messages search engine-friendly
  local ORIG_CWD="$PWD"
  local SELFPATH="$(dirname -- "$(readlink -f -- "$BASH_SOURCE")")" # busybox
  cd -- "$SELFPATH" || return $?

  local INSTALL_PREFIX='/opt' # See README.md for why not /opt/usr.

  local TARBALL="$1"; shift
  [ -n "$TARBALL" ] || TARBALL="$(printf -- '%s\n' *.tar.xz)"
  case "$TARBALL" in
    '' ) echo E: 'No tarball! Please obtain and symlink one!' >&2; return 4;;
    *$'\n'* )
      echo E: 'Too many tarballs! Please specify a filename as arg 1.' >&2
      return 4;;
    *.tar.xz ) ;;
    * )
      echo E: "Tarball filename must end with .tar.xz! Not: $TARBALL" >&2
      return 4;;
  esac
  autosetup_fallible || return $?$(echo E: "$FUNCNAME failed, rv=$?" >&2)
}


function autosetup_fallible () {
  ln -sfT -- "$SELFPATH"/npmi.sh "$INSTALL_PREFIX"/bin/npmi
  ln -sfT -- node "$INSTALL_PREFIX"/bin/nodejs

  echo D: "Detecting wrapper directory name in tarball $TARBALL…"
  local TAR_PFX='^/?node-v[\w.-]+/(lib|bin|include|share)(/|$)'
  TAR_PFX="$(unxz <"$TARBALL" | tar t | grep -m 1 -oPe "$TAR_PFX")"
  TAR_PFX="${TAR_PFX#/}"
  TAR_PFX="${TAR_PFX%%/*}"
  case "$TAR_PFX" in
    node-v* ) ;;
    * )
      echo E: "Failed to detect the wrapper directory name."
      return 4;;
  esac

  # local VER_DIR="$(basename -- "$TARBALL" .tar.xz)"
  local VER_DIR="$TAR_PFX"
  VER_DIR="${VER_DIR#node-}"
  VER_DIR="${VER_DIR%-linux-*}"
  VER_DIR="tmp.unpack.$EPOCHSECONDS.$$.$RANDOM"

  local EXTRACT=(
    include/node
    lib/node_modules/corepack
    lib/node_modules/npm
    share/doc/node
    )
  local VAL= AUX= PAR=
  for VAL in "$SELFPATH/$VER_DIR" "${EXTRACT[@]}"; do
    [ "${VAL:0:1}" == / ] || VAL="$INSTALL_PREFIX/$VAL"
    [ -d "$VAL" ] || continue
    AUX=+
    echo E: "Directory already exists, please rename or delete: '$VAL'" >&2
  done
  [ -z "$AUX" ] || return 4$(
    echo E: 'Cannot unpack: Some destination directories already exist.' >&2)

  mkdir -- "$VER_DIR" || return $?
  echo D: "Extract $TARBALL -> $VER_DIR/."

  pv "$TARBALL" | unxz | tar x -C "$VER_DIR"
  local VER_PFX="$VER_DIR/$TAR_PFX"
  for VAL in "${EXTRACT[@]}"; do
    PAR="$INSTALL_PREFIX/$(dirname -- "$VAL")"
    # echo -n "$PAR" '<-' "$VER_PFX/$VAL"; echo …
    mkdir -p -- "$PAR"
    mv -vt "$PAR"/ -- "$VER_PFX/$VAL" || return $?
    rmdir --ignore-fail-on-non-empty -p -- "$VER_PFX/$(
      dirname -- "$VAL")"
  done

  local DEST="$INSTALL_PREFIX/bin" FIX="$SELFPATH"/fixup_usr_bin_entries.sh
  mkdir -p -- "$DEST"
  mv -vt "$DEST" -- "$VER_PFX"/bin/* || return $?
  rmdir -- "$VER_PFX"/bin || return $?

  VAL="$INSTALL_PREFIX/share/doc/node"
  mv -vt "$VAL" -- "$VER_PFX"/LICENSE || return $?
  mv -vt "$VAL" -- "$VER_PFX"/*.md || return $?

  rm -- "$VER_PFX"/share/man/man*/node.* || return $?
  rmdir -p -- "$VER_PFX"/share/man/man* || return $?

  if [ -d "$VER_DIR" ]; then
    ls -Al -- "$VER_DIR"
    echo E: "There seem to be unexpected leftover files in: $VER_DIR" >&2
    return 4
  fi

  echo -n 'node.js version: '; nodejs --version || return $?
  echo -n 'npm version: '; npm --version || return $?
}











[ "$1" == --lib ] && return 0; autosetup "$@"; exit $?
