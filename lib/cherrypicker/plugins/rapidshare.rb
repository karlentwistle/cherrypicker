# Class that can sort Rapidshare link into sections as specified by RapidShare API 
#
# rapid = Rapidshare.new("http://rapidshare.com/files/329036215/The.Matrix.bandaa25.part06.rar", "username", "password")
# rapid.download
require 'open-uri'
module Cherrypicker
  class Rapidshare
    attr_accessor :link, :fileid, :filename, :hostname, :username, :password, :size, :location, :download_url
  
    def initialize(link, opts={})
      uri = URI.parse(link)
    
      o = {
        :location => nil,
        :size => nil,
        :username => nil,
        :password => nil,
      }.merge(opts)
    
      @link     = link
      @username = o[:username]
      @password = o[:password]
      @fileid   = fileid
      @size     = o[:size]
      @location = o[:location]
      @filename = File.basename(uri.path)
      @hostname = hostname
      @download_url = @hostname + remote_url
    end
  
    def download
      Download.new(@hostname + remote_url, :location => @location, :size => @size, :filename =>  @filename)
    end
  
    def fileid
      @link[/files\/(\d*)\//, 1]
    end
    
    def remote_url
      "/cgi-bin/rsapi.cgi?sub=download&" + create_url
    end
    
    def create_url
     Cherrypicker::hash_to_url({
        :fileid  =>   @fileid,
        :filename  => @filename,
        :login  =>    @username.to_s,
        :password  => @password.to_s,
      })
    end
  
    def hostname
      query = Cherrypicker::remote_query("http://api.rapidshare.com/cgi-bin/rsapi.cgi?sub=download&" + create_url)
      query.response.response["Location"][/(.*).rapidshare.com/, 1] + ".rapidshare.com"
    end  
  end
end