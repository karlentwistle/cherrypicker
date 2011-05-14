require File.dirname(__FILE__) + '/../test_helper'

module Cherrypicker
  class YoutubeTest < Test::Unit::TestCase
  
    context "Information request" do
         
      should "Standard video test" do
        response = Googlevideo.new("http://video.google.com/videoplay?docid=7065205277695921912")
        assert response.link.length > 0
        assert response.filename.length > 0
        assert response.filename == "Zeitgeist: Addendum"
        assert UrlAvailable?(response.download_url)
      end
      
      should "Standard video test" do
        response = Googlevideo.new("http://video.google.com/videoplay?docid=-7060901208354599575")
        assert response.link.length > 0
        assert response.filename.length > 0
        assert response.filename == "Charlie Chaplin A DogsLife"
        assert UrlAvailable?(response.download_url)
      end
    end
  end
end