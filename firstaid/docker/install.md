
Install docker
==============

* Download the latest `docker_*_EX2Ultra.bin` from
  https://github.com/JediNite/wdpksrc/releases
* Log into the admin panel &rarr; Apps &rarr; "Install an app manually"
* Upload the `.bin` file.
* Wait a bit (usually less than a minute)
* Admin panel should now show a message that it was installed.
* If instead the installation failed, try
  [Upgrading the ancient Docker NAS app](upgrade_ancient_app.md).



Configure or remove portainer
-----------------------------

If you want to use portainer (and it works for you), you should now
configure it, at least set an admin password.
Otherwise (it neither works for me nor do I need it), run `docker ps --all`
to find its container ID, `docker stop` it and `docker rm` it.



Docker images failing with exit code 139
----------------------------------------

Even with the latest docker version, some images will take forever to start
and then crash immediately, often with exit code 139 or 127.
This is likely due to glibc issues. In that case, a work-around may be
to use an older version of the image, or one based on Alpine Linux:


### Python

```text
# docker run --rm python:3 pwd || echo error=$?
pwd: error while loading shared libraries: libc.so.6: ELF load command address/offset not page-aligned
error=127
# docker run --rm python:3-alpine3.18 pwd || echo error=$?
error=139
# docker run --rm python:3-alpine3.17 pwd || echo error=$?
/
```


### Ubuntu

```text
# docker run --rm ubuntu:noble pwd || echo error=$?
error=139
# docker run --rm ubuntu:jammy pwd || echo error=$?
/
# docker run --rm ubuntu:focal pwd || echo error=$?
/
```


### Alpine

```text
# docker run --rm alpine:3.20 pwd || echo error=$?
error=139
# docker run --rm alpine:3.18 pwd || echo error=$?
error=139
# docker run --rm alpine:3.17 pwd || echo error=$?
/
```





