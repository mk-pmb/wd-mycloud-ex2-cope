# -*- coding: utf-8, tab-width: 2 -*-
#
# This file is meant to be plugged into /opt/etc/profile by install.sh.
#

in_func () { "$@"; }

for RC_FILE in \
  /opt/etc/profile.d/*.early/* \
  /opt/etc/profile.d/* \
  /opt/etc/profile.d/*.inc/* \
  /opt/etc/profile.d/*.late/* \
; do
  [ -f "$RC_FILE" ] || continue
  case "$(basename -- "$RC_FILE")" in
    [0-9][0-9]* | \
    [A-Z][0-9][0-9]* | \
    [A-Za-z0-9]*.sh )
      in_func . "$RC_FILE" || echo W: "Failed to source $RC_FILE: rv=$?" >&2;;
  esac
done

unset RC_FILE
