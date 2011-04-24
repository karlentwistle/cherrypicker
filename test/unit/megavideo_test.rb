require File.dirname(__FILE__) + '/../test_helper'

module Cherrypicker
  class MegavideoTest < Test::Unit::TestCase
  
    context "Information request" do
         
      should "Standard video test" do
        response = Megavideo.new("http://www.megavideo.com/?v=JKXPXMGA")
        assert response.link =~ /[A-Z]*/
        assert response.filename.length > 0
        assert response.filename == "russian+president+dancing.flv"
        assert response.download_url.include?("#{response.filename}")
        assert UrlAvailable?(response.download_url)
      end
      
      should "Another video test" do
        response = Megavideo.new("http://www.megavideo.com/?v=GYZ3NEFZ")
        assert response.link =~ /[A-Z]*/
        assert response.filename.length > 0
        assert response.filename == "justin+bieber+-+one+time.flv"
        assert response.download_url.include?("#{response.filename}")
        assert UrlAvailable?(response.download_url)
      end

    end
  end
end