
Node.js
=======


Install
-------

* Obtain a node.js tarball for the ARMv7 linux platform.
  * You can either use the [download chooser](https://nodejs.org/en/download)
    (scroll down to the "Or get a prebuilt…" part),
  * or find it in the [traditional directory listing](https://nodejs.org/dist/)
    by first selecting a recent version (e.g. `latest-v20.x/`)
    and there, find a file like `node-v20.18.1-linux-armv7l.tar.xz`.
* For transport security, you should download the tarball over HTTPS,
  but busybox's wget doesn't support that.
  Thus, use your regular browser to download it to your regular computer and…
* Copy the tarball onto a NAS share.
* Make sure you've [installed the goodies core](../).
* `cd /opt/usr/lib/ex2cope/goodies/nodejs`
* Create a symlink to the tarball: `ln -st . -- /shares/…/node-v….tar.xz`
* `./autosetup.sh`


