#!/bin/bash
# -*- coding: utf-8, tab-width: 2 -*-


function install_ghciu_and_nodejs () {
  export LANG{,UAGE}=en_US.UTF-8  # make error messages search engine-friendly
  local SELF_ABS="$(readlink -f -- "$BASH_SOURCE")" # busybox
  local SELF_DIR="${SELF_ABS%/*}"
  local COPE_DIR="${SELF_DIR%/*/*}"
  cd -- "$COPE_DIR" || return $?

  local GHCIU_REPO_NAME='github-ci-util-2405-pmb'
  local GHCIU_REPO_DEST="/opt/usr/lib/$GHCIU_REPO_NAME"
  local GHCIU_REPO_FROM="https://github.com/mk-pmb/$GHCIU_REPO_NAME.git"
  local GHCIU_REPO_BRANCH='master'
  local AIFTB='util/nodejs/autoinstall_from_tarball.sh'

  [ -d "$GHCIU_REPO_DEST" ] || git clone \
    --single-branch --branch="$GHCIU_REPO_BRANCH" \
    -- "$GHCIU_REPO_FROM" "$GHCIU_REPO_DEST" || return $?

  [ -x "$GHCIU_REPO_DEST/$AIFTB" ] || return $?$(
    echo E: "No '$AIFTB' in '$GHCIU_REPO_DEST'. Try pulling the latest" \
      "'$GHCIU_REPO_BRANCH' branch and checking that out," \
      "or rename the entire repo so it will be cloned from scratch." >&2)

  local NODEJS_DEST_PREFIX='/opt' # <- see README.md for why not /opt/usr.
  ln -sfT -- "$SELF_DIR"/npmi.sh "$NODEJS_DEST_PREFIX"/bin/npmi

  local NODEJS_TARBALLS_CACHE='tmp.cache/'
  local NODEJS_VERSION="$(grep -Pe '^\s+"engines":' -- package.json |
    grep -oPe '"node": *"[^"]+"' | cut -d '"' -sf 4)"

  local CUR_VER="$("$NODEJS_DEST_PREFIX"/bin/nodejs --version 2>/dev/null)"
  CUR_VER="${CUR_VER#v}"
  CUR_VER="${CUR_VER%%.*}"
  # echo D: "Node.js versions: cur='$CUR_VER' want='$NODEJS_VERSION'"
  case "$NODEJS_VERSION" in
    "^$CUR_VER" | \
    "$CUR_VER" )
      echo "D: Node.js autosetup: Nothing to do:" \
        "Seems like you already have Node.js v$CUR_VER installed."
      return 0;;
  esac

  local NODEJS_UNPACK_TMP_PREFIX="${NODEJS_TARBALLS_CACHE}unpacked."
  local NODEJS_INSTALL=(
    "$GHCIU_REPO_DEST/$AIFTB"
    "$NODEJS_DEST_PREFIX/"
    "$NODEJS_TARBALLS_CACHE"
    "$NODEJS_VERSION"
    --recklessly-reinstall
    "$NODEJS_UNPACK_TMP_PREFIX"
    )
  "${NODEJS_INSTALL[@]}" || return $?
}










install_ghciu_and_nodejs "$@"; exit $?
