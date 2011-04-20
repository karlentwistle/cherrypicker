# Class that can download from Vimeo
# Vimeo.new("http://www.vimeo.com/2119458", "/Volumes/Storage/Desktop/cherrytest/").download

#<!--     _
#  __   _|_|_ __ ___   ___  ___
#  \ \ / / | '_ ' _ \ / _ \/ _ \
#   \ V /| | | | | | |  __/ |_| |
#    \_/ |_|_| |_| |_|\___|\___/
#               you know, for videos
#-->

class Vimeo
  attr_accessor :link, :filename, :location, :download_url

  def initialize(link, location = "")
    @link         = link
    @filename     = ""
    @location     = location
    @download_url = ""
    
    hostname = "http://www.vimeo.com/moogaloop/play/clip"
    
    #the vimeo ID consists of decimal numbers in the URL
	  vimeo_id = @link[/\d+/]
    response = remote_query("http://www.vimeo.com/moogaloop/load/clip:#{vimeo_id}")
    title = response.body[/<caption>(.*)<\/caption>/, 1] 
    request_signature = response.body[/<request_signature>(.*)<\/request_signature>/, 1] 
    request_signature_expires = response.body[/<request_signature_expires>(\d+)<\/request_signature_expires>/, 1]	
    hd = response.body[/<isHD>(.*)<\/isHD>/, 1] 
    
    if hd.to_i == 0
		  download_url = ":#{vimeo_id}/#{request_signature}/#{request_signature_expires}"
	  else
	    download_url = ":#{vimeo_id}/#{request_signature}/#{request_signature_expires}/?q=hd"
    end
    
		@filename = title.delete("\"'").gsub(/[^0-9A-Za-z]/, '_') + ".flv"
    reply = remote_query("#{hostname}#{download_url}")
		@download_url = reply.response['location']
  end
  
  def download
    Download.new(@download_url, @location)
  end
end