#!/bin/bash
# -*- coding: utf-8, tab-width: 2 -*-
: """

The NAS's internal web server has difficulty serving large files,
with a long delay before downloads begin. One possible explanation
could be that the entire file is loaded into RAM first, instead of
being streamed.

We could make a CGI that serves one small chunk at a time, so that
wget --continue, after a lot of retries, will finally have assembled
the full file. However, since /var/www/cgi-bin/ requires login, we'd
need to configure a separate CGI directory, and even then it would be
a cumbersome hack.

Way easier: Run the simple static python3 webserver. It seems to not
be capable of serving byte ranges aka segmented download aka continue
a partial download, but at least it can stram the files properly.

"""
CTR_NAME='pywebsrv-for-large-files'
echo -n 'Stop old container: '; docker stop "$CTR_NAME" || true
echo -n 'Remove old container: '; docker rm "$CTR_NAME" || true
echo -n 'Start new container: '
DK=(
  docker run
  --detach
  --restart always
  --name "$CTR_NAME"
  --publish 88:8000
  --volume /mnt/HD:/mnt/HD:ro
  --volume /shares:/shares:ro
  --volume /var/www/pub:/var/www/pub:ro
  python:3-alpine3.17
  python3 -m http.server 8000 --directory /var/www
  )
exec "${DK[@]}"; exit $?
