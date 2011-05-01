Cherrypicker
=========

	Cherrypicker was part of my final year project for university it
	is a Ruby Gem that lets you download from; Rapidshare, Hotfile, rghost, Youtube, Vimeo & Megavideo
	You can also utilise the LinkChecker to see if your files are alive on Rapidshare and Hotfile
	
	Enjoy!

Installation
------------

	gem install cherrypicker

Usage
-----

	require 'cherrypicker'
	
Terminal Examples
--------
	Within your terminal type
	
	cherrypick

	cherrypick http://www.youtube.com/watch?v=I5DCwN28y8o -d "~/Movies"
	cherrypick http://rapidshare.com/files/453165880/test_file.txt -u "karlentwistle" -p "foobar"

	
Gem Examples
--------
	test = Rapidshare.new("http://rapidshare.com/files/329036215/myfile.rar", "username", "password")
	test.download
	
	test2 = Hotfile.new("http://hotfile.com/dl/81103855/ee51a52/myfile.rar", "username", "password")
	test2.download
	
	check = LinkChecker.new([
	  "http://rapidshare.com/files/329036215/myfile.rar", 
	  "http://rapidshare.com/files/329036764/deadfile.rar"]).status
	
	test3 = Rapidshare.new("http://rapidshare.com/files/329036215/myfile.rar", "username", "password", :size => 10000, :location => "/location/tosave/file/")
	test3.download	
	
	Vimeo.new("http://www.vimeo.com/2119458", :location => "/Volumes/Storage/Desktop/cherrytest/").download
	Youtube.new("http://www.youtube.com/watch?v=SF6I5VSZVqc", :location => "/Volumes/Storage/Desktop/cherrytest/").download
	Megavideo.new("http://www.megavideo.com/?v=2PEKD0YS", :location => "/Volumes/Storage/Desktop/cherrytest/").download
	
	Download.new("http://download.thinkbroadband.com/10MB.zip", :location => "/location/tosave/file/")
	Download.new("http://download.thinkbroadband.com/10MB.zip", :location => "/location/tosave/file/", :size => 10485760)
	
Contributing
------------

If you'd like to contribute a feature or bugfix: Thanks! To make sure your
fix/feature has a high chance of being included, please read the following
guidelines:

1. Post a new GitHub Issue[http://github.com/karlentwistle/Cherrypicker/issues].
2. Write a simple unit test that includes UrlAvailable?
	
Limitations
-----------

1. 	The download function for cyberlockers is only useful if you're using premium accounts, 
	this will not work without a valid username and password when downloading a file
	
2. 	The linkchecker is subject to throttling from both Hotfile and Rapidshare 
	so don't abuse it or your IP address could get banned
	
3. 	I frequently have problems accessing file hosting sites because one of their 
	files has been included on the IWF list and the ISP IWF filtering screws things up. 
	(Im on Virgin Media UK)
	
License
-------

	Cherypicker is free software, and may be redistributed and be used for 
	anything apart from the operation of nuclear facilities, aircraft navigation 
	or communication systems, air traffic control, life support or weapons systems.