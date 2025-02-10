#!/bin/bash
# -*- coding: utf-8, tab-width: 2 -*-


function install_goodies () {
  export LANG{,UAGE}=en_US.UTF-8  # make error messages search engine-friendly
  local SELF_ABS="$(readlink -f -- "$BASH_SOURCE")" # busybox
  local SELF_DIR="${SELF_ABS%/*}"
  local COPE_DIR="${SELF_DIR%/*/*}"
  cd -- "$COPE_DIR" || return $?

  ./goodies/nodejs/autosetup.sh || return $?$(
    echo E: 'Failed to install node.js!' >&2)

  grep --help | grep -qFe --perl-regexp || return 4$(
    echo E: >&2 "Your default grep ($(which grep
      )) doesn't understand the `--perl-regexp` option. Please upgrade it.")

  ln -sfvT "$SELF_DIR"/ex2cope-goodie.sh \
    /opt/bin/ex2cope-goodie || return $?
  ln -sfvT "$SELF_DIR"/autorun.trampoline.sh \
    /opt/etc/init.d/S50cope_goodies_autorun || return $?

  setup_etc_profile_d_support || return $?
  echo +OK 'Installed. Effects will apply when you next reboot your NAS.'
}


function setup_etc_profile_d_support () {
  local OEP='/opt/etc/profile'
  grep -Fe profile "$OEP" | grep -qFe .d ||
    echo $'\n'". '$SELF_DIR'/profile.d/source-all.inc.sh" \
    >>"$OEP" || return $?
  mkdir -p "$OEP".d
  for ARG in early inc late; do
    ln -sfT -- "$SELF_DIR"/profile.d/"$ARG" "$OEP".d/ex2cope."$ARG"
  done
}






























install_goodies "$@"; exit $?
