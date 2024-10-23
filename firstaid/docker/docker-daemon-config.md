
Docker Daemon Config
====================


Making the daemon config permanent
----------------------------------

Some fixes require custom config in `/etc/docker/daemon.json`.
However, `/etc` is on a volatile ramdisk.

We'll assume the docker "app" is installed in `/mnt/HD/HD_a2/Nas_Prog/docker`
(henceforth `$DKAPP`), and there is a `start.sh` in it.

To get a permanent docker config, we can create a directory `$DKAPP/etc`,
a file `$DKAPP/etc/daemon.json` for the config,
and then modify `$DKAPP/start.sh` to symlink all of the files in `$DKAPP/etc`
into `/etc/docker`.
I'd love to provide a proper patch, but I can't find a sufficient license
statement near the original file, so instead I'll have to describe where to
edit what:

There should be a line that defines the `APPDIR` variable,
then a commented-out line with `export PATH=`,
then a log message about "setup daemon".
Between the export and the log message lines, insert my code:

```sh
[ -d "${APPDIR}" ] || exit 4$(echo E: 'APPDIR is not a directory!' >&2)
echo 'DOCKER START: symlink the /etc/docker files'
mkdir -p -- /etc/docker
ln -ns -- "${APPDIR}"/etc/* /etc/docker/
```

(Yes, the curly braces are useless.
I just use them to match the style of the original file.)


Make sure `$DKAPP/etc/daemon.json` is valid JSON (e.g. `{}`),
create a dummy file (e.g. an empty `dummy.txt`) to test whether the
`ln` command in the above patch works for multiple files, reboot,
and check if all symlink were installed correctly into `/etc/docker`.
They should, and if so, you can delete the dummy file.
(And optionally the symlink to it. Or just wait for the next reboot.)








