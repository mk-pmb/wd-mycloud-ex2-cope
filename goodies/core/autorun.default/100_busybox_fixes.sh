#!/bin/bash
BADS=(

  sed     # b/c WD's sed doesn't understand \f.

  )
for BAD in "${BADS[@]}"; do
  BAD=/bin/"$BAD"
  [ -f "$BAD" ] || continue
  [ -x /opt"$BAD" ] || continue
  LNK="$(readlink -f -- "$BAD")"
  case "$LNK" in
    /bin/busybox | \
    busybox ) ;;
    * ) continue;;
  esac
  ln -sf /opt"$BAD" /bin/
done
