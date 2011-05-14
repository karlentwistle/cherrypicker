# Class that can download from Vimeo
# Fileserve.new("http://www.vimeo.com/2119458", :location => "/Volumes/Storage/Desktop/cherrytest/").download

require 'rubygems'
require 'mechanize'
require 'open-uri'

module Cherrypicker
  class Fileserve
    attr_accessor :link, :filename, :location, :download_url
    
    def self.matches_provider?(url)
      url.include?("fileserve.com")
    end

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
         agent.user_agent_alias = 'Mac Safari'
         agent.follow_meta_refresh = true
         page = agent.get('http://www.fileserve.com/login.php')
             
         form = signin_page.form_with(:name => 'login_form') do |form|
           form.loginUserName = o[:username]
           form.loginUserPassword = o[:password]
         end.submit  
         
         page = agent.get('http://www.fileserve.com/login.php')
        }
        
      
  		#@download_url = reply.response['location']
    end
  
    def download
     # Cherrypicker::download_file(@download_url, :location => @location, :filename => @filename)
    end
  end  
end

