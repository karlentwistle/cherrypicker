# Class that can download files from cyberlockers
#
# Download.new(hostname, url, username, password)
require 'net/http'
require 'progressbar'

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
  
private

  def download_file
    http = Net::HTTP.new("#{self.hostname}")
    http.request_get("#{self.url}") do |response|
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