#!/bin/bash
# -*- coding: utf-8, tab-width: 2 -*-
export LANG{,UAGE}=en_US.UTF-8  # make error messages search engine-friendly
CGCD="$(dirname -- "$(readlink -f -- "$BASH_SOURCE")")" # busybox
export COPE_GOODIES_CORE_DIR="$CGCD"
COPE_DIR="${CGCD%/*/*}"
export COPE_DIR
[ -n "$HOSTNAME" ] || export HOSTNAME="$(hostname -s)"

source "$@"; exit $?
