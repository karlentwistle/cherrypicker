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

      classname = URI.parse(@link.to_s).host[/[^www\.]+/].capitalize
      instance = Object.const_get('Cherrypicker').const_get("#{classname}")
      instance.new(@link, :location => @location, :username => @username, :password => @password).download
    end
  end
end