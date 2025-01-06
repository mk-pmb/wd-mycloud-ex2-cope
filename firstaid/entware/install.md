
Install entware
===============

Install the base components
---------------------------

* Navigate to the download page: [CloudSmith WD Community Repo][wdc-repo].
* When you scroll down, there will be a table with lots of info and
  a bright green "Download" button. That's a decoy.
  Or rather, it's the download button for the GPG signatures,
  as the table caption left would have already told you.
* The real download button (for the Entware NAS "app") is a bit farther up,
  above said table, in the far right.
  It should point to a URL for a file named `entware_21.04.07_EX2Ultra.bin`
  (or maybe a newer version).
* Download that file.
* Log into your NAS's web admin panel.
* Go to "Apps", and above the apps menu, select "Install an app manually".
* Select the file you just downloaded.
* Installation will probably finish in less than a minute.
* When the app was successfully installed,
  use the web admin GUI to request a reboot.

  [wdc-repo]: https://cloudsmith.io/~wd-community/repos/EX2Ultra/packages/detail/raw/entware/



Make yourself an /opt bind mount reminder
-----------------------------------------

In a few months, you may have forgotten this tutorial and wonder where that
`/opt` entry in your mount points comes from, and why it uses the same disk
as your main NAS mountpoint. So, make yourself a reminder:

```sh
cd /shares/Volume_1/entware
readlink -f . | tee _slash_opt_is_mounted_from
```

Now if my assumption is correct that `/opt` is a bind mount for that
exact directory, the newly created file should also have appeared there:

```text
cat /opt/_slash_opt_is_mounted_from
```

&#x1F44D;



Install some extra packages
---------------------------

Entware uses `opkg` as its package manager. &rArr; In an SSH session, run:<br>
`opkg install coreutils curl file findutils git git-http grep htop`
`less nano ntpdate procps-ng screen sed wget-nossl`

* You should [optimize the `screen` command](gnu_screen.md) before you use it.



### Install more conveniences

* The opkg packages from above should be enough to get your shell to a state
  where you can clone
  [terminal-util-pmb](https://github.com/mk-pmb/terminal-util-pmb) and
  [git-util-pmb](https://github.com/mk-pmb/git-util-pmb).
  * To install their binlinks[sic], you'll need npm,
    so consider [installing node.js](../nodejs/README.md), too.
* Unfortunately, the
  [docker-devel-util-pmb](https://github.com/mk-pmb/docker-devel-util-pmb)
  install script isn't compatible with busybox yet.
  Even without that, your SSH session should then be good enough for managing
  [docker](../docker/) containers, so you can do any real work in those.






