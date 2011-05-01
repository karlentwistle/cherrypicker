require File.dirname(__FILE__) + '/../test_helper'

module Cherrypicker
  class RghostTest < Test::Unit::TestCase
  
    context "Information request" do
         
      should "Standard download test" do
        response = Rghost.new("http://rghost.net/5420316")
        assert response.link =~ /\d*/
        assert response.filename.length > 0
        assert response.filename == "cherrypicker2.png"
        assert UrlAvailable?(response.download_url)
      end
      
      should "Standard download test" do
        response = Rghost.new("http://rghost.net/5420928")
        assert response.link =~ /\d*/
        assert response.filename.length > 0
        assert response.filename == "aimqpad.rar"
        assert UrlAvailable?(response.download_url)
      end

      should "Standard download test" do
        response = Rghost.new("http://rghost.net/5421019")
        assert response.link =~ /\d*/
        assert response.filename.length > 0
        assert response.filename == "saw.ogg"
        assert UrlAvailable?(response.download_url)
      end
    end
  end
end