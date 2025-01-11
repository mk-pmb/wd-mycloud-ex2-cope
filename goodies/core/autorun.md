
autorun
=======

autorun.trampoline.sh
---------------------

We want our `autorun.now.sh` to run as its own process, so we can
choose our own interpreter via shebang and would avoid sharing the
variable namespace with other startup scripts.

The Entware 21.04.07 implementation of `/opt/etc/init.d/rc.unslung`
does have code for running startup scripts as subprocesses,
based on their filename.
However, its file find command is set up to never find any such files.
It can only find files whose name will trigger the other code,
which `source`s them "for speed."

As a work-around, we symlink a proxy script whose only job is to
fork off our real autorun script.





