# Class that can download from Vimeo
# Googlevideo.new("http://video.google.com/videoplay?docid=7065205277695921912", :location => "/Volumes/Storage/Desktop/cherrytest/").download
require 'cgi'

module Cherrypicker
  class Googlevideo < PluginBase
    attr_accessor :link, :filename, :location, :download_url
    
    def self.matches_provider?(url)
      url.include?("video.google.com")
    end

    def initialize(link, opts={})
    
      o = {
        :location => nil,
      }.merge(opts)
    
      @link         = link
      @filename     = ""
      @location     = o[:location]
      @download_url = ""
      
      response = Cherrypicker::remote_query(@link)      
      @filename = response.body[/<title>(.*)<\/title>/, 1] + ".flv"
      @download_url = CGI.unescape(response.body[/videoUrl\\x3d(.*)\\x26thumbnailUrl/, 1])
    end
      
    def download
      Cherrypicker::download_file(@download_url, :location => @location, :filename => @filename)
    end
  end  
end