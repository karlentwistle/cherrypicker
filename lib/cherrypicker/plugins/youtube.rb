# Class that can download from Vimeo
# Youtube.new("http://www.youtube.com/watch?v=SF6I5VSZVqc", :location => "/Volumes/Storage/Desktop/cherrytest/").download
require 'cgi'

module Cherrypicker
  class Youtube
    attr_accessor :link, :filename, :location, :download_url

    def initialize(link, opts={})
    
      o = {
        :location => nil,
      }.merge(opts)
    
      @link         = link
      @filename     = ""
      @location     = o[:location]
      @download_url = ""
    
  		video_id = @link[/v[\/=](.*)/,1]
      video_info = Cherrypicker::remote_query("http://www.youtube.com/get_video_info?video_id=#{video_id}").body
    
  		#converting the huge infostring into a hash. simply by splitting it at the & and then splitting it into key and value arround the =
  		#credit https://github.com/rb2k/viddl-rb/blob/master/plugins/youtube.rb
  		video_info_hash = Hash[*video_info.split("&").collect { |v| 
        key, value = v.split "="
        value = CGI::unescape(value) if value
        if key =~ /_map/
          value = value.split(",")
          value = if key == "fmt_map"
              Hash[*value.collect{ |v| 
                k2, *v2 = v.split("/")
                [k2, v2]
              }.flatten(1)]
            elsif key == "fmt_url_map" || key == "fmt_stream_map"
              Hash[*value.collect { |v| v.split("|")}.flatten]
          end
        end
  			[key, value]
  		}.flatten]

  		#Standard = 34 <- flv
  		#Medium = 18 <- mp4
  		#High = 35 <- flv
  		#720p = 22 <- mp4
  		#1080p = 37 <- mp4
  		#mobile = 17 <- 3gp
  		# --> 37 > 22 > 35 > 18 > 34 > 17
  		formats = video_info_hash["fmt_map"].keys

  		format_ext = {}
  		format_ext["37"] = ["mp4", "MP4 Highest Quality 1920x1080"]
  		format_ext["22"] = ["mp4", "MP4 1280x720"]
  		format_ext["35"] = ["flv", "FLV 854x480"]
  		format_ext["34"] = ["flv", "FLV 640x360"]
  		format_ext["18"] = ["mp4", "MP4 480x270"]
  		format_ext["17"] = ["3gp", "3gp"]
  		format_ext["5"] = ["flv", "old default?"]

      download_url = video_info_hash["fmt_url_map"][formats.first]
  		@filename = video_info_hash["title"].delete("\"'").gsub(/[^0-9A-Za-z]/, '_') + "." + format_ext[formats.first].first
  		
  		#there might be a redirect let check
  		reply = Cherrypicker::remote_query("#{download_url}")
  		if reply.response['location']
  		  @download_url = reply.response['location']
  		else
  		  @download_url = download_url
  		end
    end
  
    def download
      Cherrypicker::download_file(@download_url, :location => @location, :filename  => @filename)
    end
  end
end