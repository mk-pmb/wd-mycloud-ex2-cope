
Upgrading the ancient Docker NAS app
====================================

Use this approach only if the [regular install process](install.md)
doesn't work for you or gives too old a docker.

* First, download [the ancient Docker NAS app
  ](https://github.com/WDCommunity/wdpksrc/releases/tag/docker-v20.10.14)
  and install it.
* When it is installed, stop it.
* Download the latest `docker-*.tgz` from
  https://download.docker.com/linux/static/stable/armhf/
  and unpack it to somwhere on the NAS.
  It should contain a directory named "docker".
  Let's call that the "unpacked docker directory".
  * (The unpacked docker directory should contain files named `dockerd`,
    `runc`, `containerd` and some others.)
* SSH into the NAS, chdir into `/mnt/…/Nas_Prog/docker`.
  Let's call that the "outer docker directory".
* It should contain a subdirectory also called "docker".
  Let's call that the "inner docker directory".
* Rename inner docker directory to `orig-docker` so you have it as backup
  if the next steps fail.
* Move the unpacked docker directory into the outer docker directory,
  so it becomes the new inner docker directory.
* In the admin web panel, start the Docker app.
* In your SSH session, run `docker info 2>/dev/null | head -n 15`
  to verify your client version and server version.


