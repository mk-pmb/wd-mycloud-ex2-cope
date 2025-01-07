#!/bin/bash
# -*- coding: utf-8, tab-width: 2 -*-
RECO=(

  libdir-binlinks-cfg-linker-pmb@latest

  nodever@latest

  highlight.js@latest pre2gfmarkdown-pmb@latest turndown

  easydav-jqput-pmb@latest jquery@latest

  temp-units-conv@latest

  )
exec npmi "${RECO[@]}"; exit $?
