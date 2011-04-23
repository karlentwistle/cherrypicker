#The points are decremented by 1000 per minute. If you are able to parse the http header, 
#you can parse "X-APICPU: x/y", where x stands for your current points
require 'net/http'
require 'net/https'
require 'open-uri'

module Cherrypicker
  def self.remote_query(url)  
    begin
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
      return response
    rescue SocketError
      $stderr.print "IO failed: " + $!
      raise
    end
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