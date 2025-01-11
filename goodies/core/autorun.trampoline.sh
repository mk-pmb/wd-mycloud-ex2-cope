#!/bin/sh
# ^-- Don't be fooled by this shebang, read `autorun.md`.
# -*- coding: utf-8, tab-width: 2 -*-
( echo -n "D: autorun trampoline ${1:-NO_EVENT_NAME}: "; date
  case "$1" in
    start )
      env - "$(dirname -- "$(readlink -f -- "$0")")"/autorun.now.sh;;
  esac
) 2>&1 | tee -- /var/log/cope_goodies_autorun_trampoline.log &
