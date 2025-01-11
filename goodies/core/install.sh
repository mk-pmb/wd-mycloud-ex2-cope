#!/bin/bash
# -*- coding: utf-8, tab-width: 2 -*-


function install_goodies () {
  export LANG{,UAGE}=en_US.UTF-8  # make error messages search engine-friendly
  local SELF_ABS="$(readlink -f -- "$BASH_SOURCE")" # busybox
  local SELF_DIR="${SELF_ABS%/*}"
  local COPE_DIR="${SELF_DIR%/*/*}"
  cd -- "$COPE_DIR" || return $?
  ln -sfvT "$SELF_DIR"/autorun.trampoline.sh \
    /opt/etc/init.d/S50cope_goodies_autorun || return $?
  echo +OK 'Installed. Effects will apply when you next reboot your NAS.'
}










install_goodies "$@"; exit $?
