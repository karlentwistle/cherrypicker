# Class that can sort Hotfile link into sections as specified by Hotfile API 
#
# hotfile = Hotfile.new("http://hotfile.com/dl/110589431/6ad2666/ROT007-WEB-2011.rar.html", "username", "password")
# hotfile.download

require 'open-uri'
module Cherrypicker
  class Hotfile
    attr_accessor :link, :hostname, :filename, :username, :password, :size, :location, :query
  
    def initialize(link, opts={})
      if link =~ /hotfile.com\/dl\/\d*\/[0-9a-f]*\/.*.*\.html/
        @link = link[/(.*)\.html/, 1] #remove .html from link
      else
        @link = link
      end
    
      uri = URI.parse(@link)
    
      o = {
        :location => nil,
        :size => nil,
        :username => nil,
        :password => nil,
      }.merge(opts)
    
      @username = o[:username]
      @password = o[:password]
      @size     = o[:size]
      @location = o[:location]
      @filename = File.basename(uri.path)
    end

    def download
      Download.new(download_url, :location => @location, :size => @size, :filename =>  @filename)
    end
  
    def create_url
      Cherrypicker::hash_to_url({
        :link  =>  @link,
        :username  =>  @username.to_s,
        :password  =>  @password.to_s,
      })
    end
  
    def download_url
      Cherrypicker::remote_query("http://api.hotfile.com/?action=getdirectdownloadlink&" + create_url).response.body.gsub(/\n/,'')
    end
  end
end