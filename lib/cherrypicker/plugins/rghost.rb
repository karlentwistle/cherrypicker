# Class that can download from rghost
# Rghost.new("http://rghost.net/5420316", :location => "/Volumes/Storage/Desktop/cherrytest/").download
require 'open-uri'

module Cherrypicker
  class Rghost
    attr_accessor :link, :filename, :location, :download_url

    def initialize(link, opts={})
    
      o = {
        :location => nil,
      }.merge(opts)
    
      @link         = link
      @filename     = ""
      @location     = o[:location]
      @download_url = ""
          
      #the rghost ID consists of decimal numbers in the URL
  	  rghost_id = @link[/\d+/]
      response = Cherrypicker::remote_query("http://rghost.net/#{rghost_id}")
      
      @filename = response.body[/<title>(.*\.[a-zA-Z]*).*RGhost/, 1]
      download_url = URI.encode(response.body[/<a href="(.*)" class=\"(file_link|download_link)\"/, 1])
      
      reply = Cherrypicker::remote_query("#{download_url}")
    	if reply.response['location']
    		@download_url = reply.response['location']
    	else
    		@download_url = download_url
    	end
    end
  
    def download
      Cherrypicker::download_file(@download_url, :location => @location)
    end
  end
end