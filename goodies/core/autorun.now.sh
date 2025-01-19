#!/opt/bin/ex2cope-goodie
# -*- coding: utf-8, tab-width: 2 -*-


function goodies_autorun_now () {
  exec </dev/null
  cd -- "$COPE_DIR" || return $?

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
