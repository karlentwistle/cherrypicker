#The points are decremented by 1000 per minute. If you are able to parse the http header, 
#you can parse "X-APICPU: x/y", where x stands for your current points

# it will try and auto detect the size and filename if not supplied
# Cherrypicker::download_file("http://download.thinkbroadband.com/10MB.zip", :location => '/location/tosave/file/', :size => 10485760)

require 'rubygems'
require 'net/http'
require 'net/https'
require 'progressbar'
require 'open-uri'
require 'cgi'

module Cherrypicker
  class PluginBase
    class << self; attr_reader :registered_plugins end
      @registered_plugins = []

    def self.inherited(child)
      PluginBase.registered_plugins << child
    end
  end
  
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
    http.open_timeout = 3 # seconds
    http.read_timeout = 3 # seconds
    request = Net::HTTP::Get.new(uri.request_uri)
    request.initialize_http_header({"User-Agent" => Cherrypicker::random_agent})

    head = http.request_head(URI.escape(uri.request_uri))
    case head
    when Net::HTTPForbidden
      @size = nil  #no content-length no progress bar
    else
      @size = head['content-length'] if @size.nil? && head['content-length'].to_i > 1024
    end
    
    puts "unknown file size for #{@filename} but downloading..." if @size.nil?
    puts @link.to_s
    
    http.request(request) do |response|
      bar = ProgressBar.new((@filename ||= File.basename(uri.path)), @size.to_i) unless @size.nil?
      bar.format_arguments=[:title, :percentage, :bar, :stat_for_file_transfer] unless @size.nil?
            
      File.open(@location + (@filename ||= File.basename(uri.path)), "wb") do |file|
        response.read_body do |segment|
          @progress += segment.length
          bar.set(@progress) unless @size.nil?
          file.write(segment)
        end
      end
    end
        
    @finished = true
    puts
    puts "download completed"
    puts
  end

  def self.hash_to_url(hash)
    hash.keys.inject('') do |query_string, key|
      query_string << '&' unless key == hash.keys.first
      query_string << "#{URI.encode(key.to_s)}=#{URI.encode(hash[key])}"
    end
  end

  def self.random_agent
    useragent = [ "Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.3) Gecko/20090913 Firefox/3.5.3",
    "Mozilla/5.0 (Windows; U; Windows NT 6.1; en; rv:1.9.1.3) Gecko/20090824 Firefox/3.5.3 (.NET CLR 3.5.30729)",
    "Mozilla/5.0 (Windows; U; Windows NT 5.2; en-US; rv:1.9.1.3) Gecko/20090824 Firefox/3.5.3 (.NET CLR 3.5.30729)",
    "Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.1.1) Gecko/20090718 Firefox/3.5.1",
    "Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US) AppleWebKit/532.1 (KHTML, like Gecko) Chrome/4.0.219.6 Safari/532.1",
    "Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.1; WOW64; Trident/4.0; SLCC2; .NET CLR 2.0.50727; InfoPath.2)",
    "Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.0; Trident/4.0; SLCC1; .NET CLR 2.0.50727; .NET CLR 1.1.4322; .NET CLR 3.5.30729; .NET CLR 3.0.30729)",
    "Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 5.2; Win64; x64; Trident/4.0)",
    "Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 5.1; Trident/4.0; SV1; .NET CLR 2.0.50727; InfoPath.2)Mozilla/5.0 (Windows; U; MSIE 7.0; Windows NT 6.0; en-US)",
    "Mozilla/4.0 (compatible; MSIE 6.1; Windows XP)",
    "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1)",
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_6_7) AppleWebKit/534.24 (KHTML, like Gecko) Chrome/11.0.696.50 Safari/534.24"]
    return useragent[rand(useragent.length)]
  end
end