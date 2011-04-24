require 'rubygems'
require 'shoulda'
require 'net/http'

require File.dirname(__FILE__) + '/../lib/cherrypicker'

def UrlAvailable?(url)
  uri = URI.parse(url)
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true if uri.scheme == "https"
  http.start do |http|
    return http.head(uri.request_uri).code == "200"
  end
end