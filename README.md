
<!--#echo json="package.json" key="name" underline="=" -->
wd-mycloud-ex2-cope
===================
<!--/#echo -->

<!--#echo json="package.json" key="description" -->
POV: You somehow ended up with a (used) &quot;WD MyCloud EX2&quot; NAS and
since it was free, you want to somehow make use of it despite its user-hostile
operating system.
<!--/#echo -->



First aid
---------

The host OS is FUBAR except for the Apache, so let's try and get docker
running asap so we can do anything in a virtually° sane environment.
See the [`firstaid/`](firstaid/) directory for some notes on that.





⚠☠ Data loss warning ☠⚠
-----------------------

I learned the hard way that the EX2 can one day randomly decide to no longer
like some things even if they had previously worked reliably for months:

* When you develop a NAS app directly in `/shares/Volume_1/Nas_Prog/`,
  and for some reason at any time (probably at reboot) the NAS considers
  the app broken, you may discover that directory being replaced with an
  old backup. Your progress has been discarded.
* When you write a file via sshfs, you may discover that while the size
  is correct, all the bytes in the file are zero.
  Your kernel log then may or may not show several kernel panics,
  interleaved with reassuring messages such as
  ```text
  EXT4-fs error (device md1): ext4_lookup:1585: inode #39845900: comm restsdk-server: deleted inode referenced: 39846001
  EXT4-fs (md1): Delayed block allocation failed for inode 96206855 at logical offset 0 with max blocks 1 with error 117
  EXT4-fs (md1): This should not happen!! Data will be lost
  ```
  * I totally agree with the last message. "This should not happen!!"
  * Your data is FUBAR, but at least now you have an opportunity to go on
    [a great adventure about how to fsck!](firstaid/raid/fsck.md)






Known issues
------------

* Very outdated software. See disclaimer above.
* If you change the LAN settings and suddenly the web interface seems to no
  longer be reachable, it probably just redirected you improperly.
  Keep cool and just surf to the known-good URL of the web interface.




&nbsp;


License
-------
<!--#echo json="package.json" key=".license" -->
ISC
<!--/#echo -->
