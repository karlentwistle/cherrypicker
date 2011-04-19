Cherrypicker
=========

	Cherrypicker was part of my final year project for university it
	is a Ruby Gem that lets you download from; Rapidshare or Hotfile
	You can also utilise the LinkChecker to see if your files are 
	alive on Rapidshare or Hotfile
	
	Enjoy!

Installation
------------

	gem install cherrypicker

Usage
-----

	require 'cherrypicker'
	
Examples
--------

	test = Rapidshare.new("http://rapidshare.com/files/329036215/myfile.rar", "username", "password")
	test.download
	
	test2 = Hotfile.new("http://hotfile.com/dl/81103855/ee51a52/myfile.rar", "username", "password")
	test2.download
	
	check = LinkChecker.new([
	  "http://rapidshare.com/files/329036215/myfile.rar", 
	  "http://rapidshare.com/files/329036764/deadfile.rar"]).status
	
	test3 = Rapidshare.new("http://rapidshare.com/files/329036215/myfile.rar", "username", "password", "size", "/location/tosave/file/")
	test3.download	
	
	Download.new("http://download.thinkbroadband.com/10MB.zip", "/location/tosave/file/")
	Download.new("http://download.thinkbroadband.com/10MB.zip", "/location/tosave/file/", "10485760")
	
Contributing
------------

If you'd like to contribute a feature or bugfix: Thanks! To make sure your
fix/feature has a high chance of being included, please read the following
guidelines:

1. Post a new GitHub Issue[http://github.com/karlentwistle/Cherrypicker/issues].
	
Limitations
-----------

1. 	The download function is only useful if you're using premium accounts, 
	this will not work without a valid username and password when downloading a file
	
2. 	The linkchecker is subject to throttling from both Hotfile and Rapidshare 
	so don't abuse it
	
3. 	I frequently have problems accessing file hosting sites because one of their 
	files has been included on the IWF list and the ISP IWF filtering screws things up. 
	(Im on Virgin Media)
	
License
-------

	Cherypicker is free software, and may be redistributed and be used for 
	anything apart from the operation of nuclear facilities, aircraft navigation 
	or communication systems, air traffic control, life support or weapons systems.