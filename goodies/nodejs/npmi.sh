#!/bin/bash
# -*- coding: utf-8, tab-width: 2 -*-
export LANG{,UAGE}=en_US.UTF-8  # make error messages search engine-friendly
NPM_CMD=(
  # sudo -E -u lan --
  "$(which npm)"
  install
  --no-save
  --global
  --no-package-lock
  --foreground-scripts
  --no-func
  )
exec "${NPM_CMD[@]}" "$@"; exit $?
