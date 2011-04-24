require File.dirname(__FILE__) + '/../test_helper'
module Cherrypicker

  class RapidshareTest < Test::Unit::TestCase
  
    context "Information request" do
         
        should "return response https file" do
          response = Rapidshare.new("https://rapidshare.com/files/453165880/test_file.txt", :username =>  "username", :password =>  "password")
          assert response.fileid =~ /\d*/
          assert response.filename.length > 0
          assert response.hostname.length > 0
          assert UrlAvailable?(response.download_url)
        end
        
        should "return response http file" do
          response = Rapidshare.new("http://rapidshare.com/files/453165880/test_file.txt", :username =>  "username", :password =>  "password")
          assert response.fileid =~ /\d*/
          assert response.filename.length > 0
          assert response.hostname.length > 0
          assert UrlAvailable?(response.download_url)
        end
    
    end
  
  end
end