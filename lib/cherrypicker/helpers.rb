#The points are decremented by 1000 per minute. If you are able to parse the http header, 
#you can parse "X-APICPU: x/y", where x stands for your current points

# it will try and auto detect the size and filename if not supplied
# Cherrypicker::download_file("http://download.thinkbroadband.com/10MB.zip", :location => '/location/tosave/file/', :size => 10485760)

require 'rubygems'
require 'net/http'
require 'net/https'
require 'progressbar'
require 'open-uri'

module Cherrypicker
  def self.remote_query(url)  
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true if uri.scheme == "https"
    http.open_timeout = 3 # seconds
    http.read_timeout = 3 # seconds
    request = Net::HTTP::Get.new(uri.request_uri)
    request.initialize_http_header({"User-Agent" => random_agent})
    response = http.request(request)
    if response["X-APICPU"]
      if (response["X-APICPU"][/(\d*)\/\d*/, 1]).to_i > 9500
        sleep 60  # seconds
      end
    end
    return http.request(request)
  end
  
  def self.download_file(link, opts={})
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

  def self.hash_to_url(hash)
    hash.keys.inject('') do |query_string, key|
      query_string << '&' unless key == hash.keys.first
      query_string << "#{URI.encode(key.to_s)}=#{URI.encode(hash[key])}"
    end
  end

  def self.random_agent
    @useragent = ["Mozilla/5.0 (Macintosh; Intel Mac OS X 10_6_7) AppleWebKit/534.24 (KHTML, like Gecko) Chrome/11.0.696.50 Safari/534.24"]
    return @useragent[0]
  end
end