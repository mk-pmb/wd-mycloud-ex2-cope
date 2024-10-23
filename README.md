
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
