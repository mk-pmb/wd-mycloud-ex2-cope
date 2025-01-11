
Node.js
=======


Why we install into `/opt/lib` rather than `/opt/usr/lib`
---------------------------------------------------------

* Please check the progress on [the related feature request
  ](https://github.com/WDCommunity/wdpksrc/issues/125) and it it's still
  open, consider whether you may be able to help.
* Node.js expects a congruent directory structure with the same prefix
  for `$PREFIX/bin` and `$PREFIX/lib/node_modules`.
* For example, the `npm` entry points to `../lib/node_modules/npm/…`.
* Only `/opt/bin` is in Entware's `$PATH`. `/opt/usr/bin` is not.
* We could make symlinks from `/opt/bin` to `/opt/usr/bin`, but we'd have
  to do that every time the user installs a package that wants to provide
  a system-wide CLI command.
* Thus, currently, the most stable solution seems to be to do the dirty thing
  and install node.js in a place that should usually be reserved for essential
  system libraries.



Install node.js itself
----------------------

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
* If the last two lines of output are "node.js version: …" and
  "npm version: …", and the version numbers shown are what you expect,
  installation was successful.
* You can now use the global CLI command `npmi` to safely¹ install packages
  globally. (¹ Without the danger of npm deleting hundreds of folders in
  `node_modules` because it thinks they were no longer needed.)












