
Node.js
=======

Quick start
-----------

> ⚠ Anything that is using node.js while you update it, will probably break.

* Usually you don't need this guide, because the goodies core installer
  should already have done all of this.
* If for some reason it didn't and you want to debug it, run: `./autosetup.sh`
  * If the last two lines of output are "node.js version: …" and
    "npm version: …", and the version numbers shown are what you expect,
    installation was successful.
  * You can now use the global CLI command `npmi` to safely¹ install packages
    globally. (¹ Without the danger of npm deleting hundreds of folders in
    `node_modules` because it thinks they were no longer needed.)
* You may also repeat this step in hopes of updating your node.js version.
  * Updates may be limited by compatibility issues.



Why we install into `/opt/lib` rather than `/opt/usr/lib`
---------------------------------------------------------

* Please check the progress on [the related feature request
  ](https://github.com/WDCommunity/wdpksrc/issues/125)
  and if it's still open, consider whether you may be able to help.
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



















<!-- This line is dedicated to Florian Balmer. -->
