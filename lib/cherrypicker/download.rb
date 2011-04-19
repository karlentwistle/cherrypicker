# Class that can download files from cyberlockers or generic URLs
#
# Download.new("http://download.thinkbroadband.com/10MB.zip", "/location/tosave/file/")
# Download.new("http://download.thinkbroadband.com/10MB.zip", "/location/tosave/file/", "10485760")

require 'net/http'
require 'net/https'
require 'progressbar'
require 'open-uri'

class Download
  attr_accessor :link, :size, :location, :progress
  
  def initialize(link, location = nil, size = nil)
    @link     = link
    @size     = size
    @location = location
    @progress = 0
 
    download_file
  end

  def download_file
    uri = URI.parse(@link.to_s)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true if uri.scheme == "https"
    request = Net::HTTP::Get.new(uri.request_uri)
    request.initialize_http_header({"User-Agent" => random_agent})
    @size = http.request_head(URI.escape(uri.path))['content-length'].to_i if @size.nil?
    http.request(request) do |response|
      bar = ProgressBar.new(File.basename(uri.path), @size.to_i)
      File.open(@location + File.basename(uri.path), "wb") do |file|
        response.read_body do |segment|
          @progress += segment.length
          bar.set(@progress)
          file.write(segment)
        end
      end
    end
  end
end