# Class that can download files from cyberlockers or generic URLs 
# it will try and auto detect the size and filename if not supplied
# Download.new("http://download.thinkbroadband.com/10MB.zip", :location => '/location/tosave/file/') 
# Download.new("http://download.thinkbroadband.com/10MB.zip", :location => '/location/tosave/file/', :size => 10485760)

require 'rubygems'
require 'net/http'
require 'net/https'
require 'progressbar'
require 'open-uri'

module Cherrypicker
  class Download
    attr_accessor :link, :size, :location, :progress, :filename, :finished
  
    def initialize(link, opts={})
      o = {
        :location => nil,
        :size => nil,
        :filename => nil
      }.merge(opts)
    
      @link = link
      @size = o[:size]
      @location = o[:location] ||= ""
      @filename = o[:filename]
      @progress = 0
      @finished = false 
    
      download_file
    end

    def download_file
      uri = URI.parse(@link.to_s)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true if uri.scheme == "https"
      request = Net::HTTP::Get.new(uri.request_uri)
      request.initialize_http_header({"User-Agent" => Cherrypicker::random_agent})
      unless (uri.host.include? 'youtube.com') && (uri.request_uri.include? 'videoplayback') #youtube throws EOFError
        head = http.request_head(URI.escape(uri.path))
        case head
        when Net::HTTPForbidden
          @size = nil  #no content-length no progress bar
        else
          @size = head['content-length'] if @size.nil? && head['content-length'].to_i > 1024
        end
      end
      http.request(request) do |response|
        bar = ProgressBar.new((@filename ||= File.basename(uri.path)), @size.to_i) unless @size.nil?
        File.open(@location + (@filename ||= File.basename(uri.path)), "wb") do |file|
          response.read_body do |segment|
            @progress += segment.length
            bar.set(@progress) unless @size.nil?
            file.write(segment)
          end
        end
      end
      @finished = true
    end
  end
end