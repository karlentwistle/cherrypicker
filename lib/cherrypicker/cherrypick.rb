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
      
      plugins = ["Hotfile", "Megavideo", "Rapidshare", "Rghost", "Vimeo", "Youtube"]
      classname = URI.parse(@link.to_s).host[/[^www\.]+/].capitalize
      
      supported_host = plugins.include?(classname)
      
      if supported_host == true
        instance = Object.const_get('Cherrypicker').const_get("#{classname}")
        instance.new(@link, :location => @location, :username => @username, :password => @password).download
      else
        Cherrypicker::download_file(@link, :location => @location)
      end
      
    end
  end
end