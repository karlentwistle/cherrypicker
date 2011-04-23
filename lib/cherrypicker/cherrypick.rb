include Cherrypicker
require 'open-uri'

module Cherrypicker
  class Cherrypick
    attr_accessor :link, :directory, :username, :password

    def initialize(link, opts={})
      o = {
        :directory => nil, 
        :username  => nil,
        :password  => nil,
      }.merge(opts)
    
      @link         = link
      @username     = o[:username]
      @password     = o[:password]
      @directory    = o[:directory]

      host = URI.parse(@link.to_s).host[/[^www\.]+/].capitalize
      Cherrypicker::host.new(@link, :location => @directory, :username => @username, :password => @password)
    end
  end
end