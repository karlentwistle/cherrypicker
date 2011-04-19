# Class that can download files from cyberlockers
#
# Download.new(hostname, url, size, password)
require 'net/http'
require 'net/https'
require 'progressbar'
require 'open-uri'

class Download
  attr_accessor :hostname, :url, :filename, :size, :progress, :location
  
  def initialize(hostname, url, filename, size = nil, location = nil)
    @hostname = hostname
    @url      = url
    @filename = filename
    @size     = size
    @location = location
    @progress = 0
 
    download_file
  end

  def download_file
    uri = URI.parse("#{self.hostname}" + "#{self.url}")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true if uri.scheme == "https"
    request = Net::HTTP::Get.new(uri.request_uri)
    request.initialize_http_header({"User-Agent" => random_agent})
    http.request(request) do |response|
      bar = ProgressBar.new("#{self.filename}", self.size.to_i)
      File.open("#{self.location}" + "#{self.filename}", "wb") do |file|
        response.read_body do |segment|
          self.progress += segment.length
          bar.set(self.progress)
          file.write(segment)
        end
      end
    end
  end
end