#!/usr/bin/ruby
$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '..', 'lib')
require 'cherrypicker'

def usage()
	puts "Cherrypicker lets you download from; Rapidshare, Hotfile, Hotfile, Youtube, Vimeo & Megavideo"
	puts 
	puts "Usage: cherrypick link directory [--username|-u] [--password|-p]"
	puts
	puts "example: cherrypick http://www.youtube.com/watch?v=I5DCwN28y8o ~/Movies"
	puts
	puts "example: cherrypick http://rapidshare.com/files/453165880/test_file.txt -u karlentwistle -p foobar"
end

if not ARGV[0]
	usage
	exit
end

#Cherrypick.new(ARGV)
