#!/bin/bash
# -*- coding: utf-8, tab-width: 2 -*-

function install_apache2_extras () {
  local A2DIR='/usr/local/apache2'
  local A2EXTRA='/opt/etc/apache2.extras'

  mkdir -p "$A2DIR"/var/DavLock
  mkdir -p "$A2EXTRA"
  ln -s -- "$A2EXTRA" /etc/
  ln -sT -- "$A2DIR"/conf /etc/apache2
  ln -sT -- "$A2EXTRA" "$A2DIR"/@opt
  local TLE='/opt/var/www-extras/toplevel'
  mkdir -p "$TLE"/pub
  ln -s -- "$TLE"/[a-z]* /var/www/
  ln -s -- /var/www/icons "$A2DIR"/

  printf "Include $A2EXTRA/%s-enabled/*.%s\n" \
    mods load \
    mods conf \
    config conf \
    sites conf \
    >"$A2DIR"/conf/extra/opt.inc.conf


  # This `env` invocation ensures that apache is run with default environment
  # even if this installer script is invoked in a user shell:
  env - sh -c '. /etc/profile && httpd -k restart'
}






install_apache2_extras "$@"; exit $?
