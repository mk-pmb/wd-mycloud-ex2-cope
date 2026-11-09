#!/opt/bin/ex2cope-goodie
# -*- coding: utf-8, tab-width: 2 -*-
cd -- "$COPE_DIR" || exit $?
grep -hPe '^((^|\.)\d+){4}\s' -- /dev/null $(
  ./goodies/core/find_config_files.sh etc_hosts .txt
  ) | grep -vxFf /etc/hosts >>/etc/hosts; exit 0
