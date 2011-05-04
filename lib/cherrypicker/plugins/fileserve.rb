# Class that can download from Vimeo
# Fileserve.new("http://www.vimeo.com/2119458", :location => "/Volumes/Storage/Desktop/cherrytest/").download

require 'rubygems'
require 'mechanize'

module Cherrypicker
  class Fileserve
    attr_accessor :link, :filename, :location, :download_url

    def initialize(link, opts={})
    
      o = {
        :location => nil,
        :username => nil,
        :password => nil,
      }.merge(opts)
    
      @link         = link
      @filename     = ""
      @location     = o[:location]
      @download_url = ""
      
      hostname = "http://www.fileserve.com/file/JmcsvYZ/Thor.2011.TS.READNFO.XViD-IMAGiNE.avi"
    
      a = Mechanize.new { |agent|
         agent.user_agent_alias = Cherrypicker::self.random_agent
         agent.follow_meta_refresh = true
      }
      
      
      a.get(hostname) do |page|
        download_page = page.form_with(:name => 'loginForm') do |login|
        login.loginUserName = o[:username]
        login.loginUserPassword = o[:password
        end.submit

        puts a
      end
      
  		#@download_url = reply.response['location']
    end
  
    def download
     # Cherrypicker::download_file(@download_url, :location => @location, :filename => @filename)
    end
  end
end