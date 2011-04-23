include Cherrypicker
require 'open-uri'

module Cherrypicker
  class Cherrypick
    attr_accessor :link, :location, :username, :password

    def initialize(link, opts={})
      o = {
        :location => nil, 
        :username  => nil,
        :password  => nil,
      }.merge(opts)
    
      @link         = link
      @username     = o[:username]
      @password     = o[:password]
      @directory    = o[:location]

      host = URI.parse(@link.to_s).host[/[^www\.]+/].capitalize
      Cherrypicker::host.new(@link, :location => @location, :username => @username, :password => @password)
    end
  end
end