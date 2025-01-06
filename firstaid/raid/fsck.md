
fsck
====

The problem
-----------

```text
# dmesg | grep fsck
[   58.334440] EXT4-fs (md1): warning: mounting fs with errors, running e2fsck is recommended
```

Yeah. I wish there was an option for having that done at startup!



The official tutorial
---------------------

Well, at least there is an [official guide on how to fsck][wd-answer-30057].
And of course it's rather confusing.

  [wd-answer-30057]: https://web.archive.org/web/20250106/https://support-en.wd.com/app/answers/detailweb/a_id/30057

The first part, how to run fsck via the web admin GUI, is quite tame.
Following it was easy, but…


The "Fail"
----------

… in the "Click Finish" step, the tutorial screenshot shows the message

> "The Volume has been successfully scanned. No errors found."

That's not what I have. On my screen, the message next to "Volume 1"
is just one word: "Fail"

Would be really nice if the official tutorial had any advice on what to
do in that case, right?

#### Update: The official repair instructions

By chance I noticed that the alert bell had become red, and it says:

> "File system check has detected errors on your drive configuration. Backup
> your data and recreate the drive configuration to resolve these errors."

… which is usually the safest option for regular users.
However, I know from the read-only fsck run that the errors in my case
are very well repairable, and that should be a lot quicker (few minutes)
than a full backup and restore (several hours).


The command-line (SSH) guide
----------------------------

Fortunately, they also have an SSH guide just below.

The first confusion here is, why do you have to run `umount /dev/md1` twice?
Probably because there are bind mounts.
Not sure though, since the commands in the "copy these" box are in the
reverse order of what the screenshot shows. So maybe their 2nd attempt
was just required because the first attempt failed.

In my case, since I have the entware and docker app installed, I have
two bind mounts:

```text
# mount | grep md1
/dev/md1 on /mnt/HD/HD_a2 type ext4 (rw,noatime,…)
/dev/md1 on /opt type ext4 (rw,noatime,…)
/dev/md1 on /mnt/HD/HD_a2/Nas_Prog/_docker type ext4 (rw,noatime,…)
```

* The `_docker` mount is easy to disable: Just find the docker app in the
  web admin panel and stop it.
* The `/opt` mount is a bind mount for `/mnt/HD/HD_a2/entware`,
  and it persists even if you stop the entware app. (Even after reboot.)

What to do?

* You cannot just `umount /opt` because the device would still be busy.
* You can umount it lazily (`umount -l /opt`) to make it vanish from the mount
  table, but fsck would still know it is busy and would refuse to repair.
* Maybe the kill command from the tutorial
  (`/usr/sbin/kill_process.sh /dev/md1`)
  would work, but fortunately I found an even easier way:


Easily umount `/opt`
--------------------

1.  Run `mount | grep md1` to verify that `/mnt/HD/HD_a2` and `/opt`
    are the only current mounts.
1.  (optional) Run `echo "$PATH" | grep opt` or `which ls` to see why
    your current SSH session is probably using `/opt`. Thus:
1.  Quit all your SSH sessions in the NAS.
1.  Use the web admin GUI to start a disk scan as described in the tutorial:
    Settings &rarr; Utilities &rarr; (scroll down) Scan Disk &rarr;
    All Volume(s) &rarr; Scan Disk &rarr; OK.
1.  Wait patiently for the dialog that says
    "This volume has been successfully scanned."
    while the line below shows "Volume_1: Fail".
    Successfully failing, that's the WD NAS user experience!
1.  Now, while that dialog is still open, log into SSH.
1.  Let the web admin GUI sit in the background.
    You will probably be logged out due to inactivity. Let it happen.
1.  `mount | grep md1` to see that there is no longer an `/opt` entry!
    The only remaining mount should be `/mnt/HD/HD_a2`.
1.  `cd /var/www` because your home directory is going to be umounted,
    so your shell should be somewhere that is not affected.
    And being in the webspace is a good idea because that way we can have
    e2fsck create an undo file and a log file in a location where they will
    be easy to download.
1.  `umount /mnt/HD/HD_a2`
1.  `mount | grep md1` should now be empty!
1.  (optional) `e2fsck --help` to better understand the next command.
1.  `e2fsck -p -v -z e2fsck.undo /dev/md1 2>&1 | tee e2fsck.log.txt`
    * To undo: `e2undo e2fsck.undo /dev/md1`
1.  If it ends with
    `/dev/md1: UNEXPECTED INCONSISTENCY; RUN fsck MANUALLY.`
    you'll have to repeat without the `-p` option.
    * And for interactive mode, we cannot redirect the output:
      `e2fsck: need terminal for interactive repairs`
    * However, to prepare for the adventure, you can get a preview of what
      messages will be shown and what questions will be asked of you:<br>
      `e2fsck -v -n /dev/md1 2>&1 | tee e2fsck.preview.txt`
      &rarr; http://ex2nas.local/e2fsck.preview.txt
    * If you're in a YOLO mood, you can replace the `-p` option with
      `-y` to just do whatever, rather than answering individually:<br>
      `e2fsck -v -y -z e2fsck.undo /dev/md1 2>&1 | tee e2fsck.log.txt`
1.  Finally! Your file system should be healthy again. Let's verify that:<br>
    `e2fsck -v -n /dev/md1`
    &rarr; `/dev/md1: clean, […]` (hopefully)
1.  Quit the SSH session.
1.  We'll reboot soon, which will reset the webspace.
    If you want to download your undo file (http://ex2nas.local/e2fsck.undo)
    or your log file (http://ex2nas.local/e2fsck.log.txt), do it __NOW__.
1.  Back to the web admin GUI. You'll probably need to login again.
    We're trying to summon the Disk Scan Failure dialog once again.
    Go to Settings &rarr; Utilities. Wait a second or two.
    Maybe it will already appear.
    Otherwise, scroll down to the "Scan Disk" section.
    It should show an empty progress bar with the text "Initializing"
    right of it. Wait another few seconds if needed.
    Now the Disk Scan Failure dialog should really have popped up again.
1.  In the Disk Scan Failure dialog, click the "Finish" button.
1.  Bear with the "Please wait" dialog for up to two minutes.
1.  Use the web admin GUI to request a reboot.
1.  Log into the web admin GUI again.
1.  Go to "Apps" and re-enable docker.
1.  While you're there, also make sure Entware is enabled.
    It probably still is, because there was no reason to disable it.
1.  Log into SSH and run yet another read-only fsck to verify
    your effort was worth it:<br>
    `e2fsck -nf /dev/md1`
    * If it reports errors, just think of the "This is fine" burning room meme,
      run `dmesg | grep fsck`, and if that comes up empty,
      hope that the file system was clean at boot and the current errors
      are just a symptom of the file system currently being mounted and
      probably having active operations.
    * Wrong block counts can occurr due to pending write operations in the
      journal, and/or lazy inode table updates.
      Both can realistically happen while the FS is mounted.
1.  Quit the SSH session.
1.  Again, request a reboot via the web admin GUI.
    (To ensure all potentially re-enabled apps are running normally.)
























