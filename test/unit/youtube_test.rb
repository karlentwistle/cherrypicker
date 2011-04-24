require File.dirname(__FILE__) + '/../test_helper'

module Cherrypicker
  class YoutubeTest < Test::Unit::TestCase
  
    context "Information request" do
         
      should "Standard video test" do
        response = Youtube.new("http://www.youtube.com/watch?v=ihYq2dGa29M")
        assert response.link =~ /\?v=([a-z0-9\-]+)\&*/
        assert response.filename.length > 0
        assert response.filename == "Why_do_people_laugh_at_creationists___part_24_.flv"
        response.download_url.include?("videoplayback?sparams=id")
        assert UrlAvailable?(response.download_url)
      end
      
      should "Another video test" do
        response = Youtube.new("http://www.youtube.com/watch?v=nZ6-GnxKuwY")
        assert response.link =~ /\?v=([a-z0-9\-]+)\&*/
        assert response.filename.length > 0
        assert response.filename == "The_Palace_Episode_02.mp4"
        response.download_url.include?("videoplayback?sparams=id")
        assert UrlAvailable?(response.download_url)
      end
     
    end
  end
end