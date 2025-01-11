#!/bin/sh
BAD=

BAD+=' sed' # b/c WD's sed doesn't understand \f.

BAK=/bin/busybox.inferior.bak
mkdir -p -- "$BAK"
for BAD in $BAD; do
  BAD=/bin/"$BAD"
  [ -x /opt"$BAD" ] || continue
  mv -n -- "$BAD" "$BAK"/
  cp -- /opt"$BAD" /bin/
done
