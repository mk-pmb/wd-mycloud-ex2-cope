
Install entware
===============

* __Install the base components:__
  :TODO: How did I do that?
* __Install some extra packages:__
  Entware uses `opkg` as its package manager.
  &rArr; `opkg install coreutils curl file findutils git git-http grep htop`
  `less nano ntpdate procps-ng screen sed wget-nossl`
  * Those should be enough to get your shell to a state where you can install
    [terminal-util-pmb](https://github.com/mk-pmb/terminal-util-pmb) and
    [git-util-pmb](https://github.com/mk-pmb/git-util-pmb).
    Unfortunately, the
    [docker-devel-util-pmb](https://github.com/mk-pmb/docker-devel-util-pmb)
    install script isn't compatible with busybox yet.
    Still, even without that, your SSH session should then be good enough
    for managing docker containers, so you can do any real work in those.



