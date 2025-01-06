
GNU screen
==========

On entware, your `screen` sessions would usually be stored in
`/opt/tmp/screen`, i.e. on the NAS disk drives.

That makes no sense, as it has only disadvantages:

* Having the old ones around after reboot is useless (they won't work anymore)
  and cumbersome (screen will be confused by their presence).
* Disks should not have to spin up just because you start a screen session.

It would be much better to store those sessions in `/tmp`, which is on the
volatile RAM disk. We can symlink `/opt/tmp/screen` to `/tmp/screen`,
but someone would have to create the latter after each reboot.

Fortunately, a simple entware init script can do that!
Use these commands to create it:

* You don't need this if you install [the goodies](../../goodies/)
  because they already do the same thing.
* ⚠ This script ignores the event type and thus will run on way too many
  occasions, including `clean` and `stop`. However, the simplicity of its
  actions allows us to run it indiscriminately without damage.

```sh
D=/opt/etc/init.d/S10gnu_screen_tmp
printf '%s\n' '#!/bin/sh' 'mkdir -p /tmp/screens' \
  'ln -sf /tmp/screens /opt/tmp/' >"$D"
chmod a+x -- "$D"
```

… and reboot the NAS to test if the script works.







