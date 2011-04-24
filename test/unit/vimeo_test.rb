require File.dirname(__FILE__) + '/../test_helper'

module Cherrypicker
  class VimeoTest < Test::Unit::TestCase
  
    context "Information request" do
         
      should "Standard video test" do
        response = Vimeo.new("http://vimeo.com/12650554")
        assert response.link =~ /\d*/
        assert response.filename.length > 0
        assert response.filename == "Portland_Cello_Project___Denmark.flv"
        assert response.download_url.include?("token")
        assert UrlAvailable?(response.download_url)
      end
      
      should "URL with a ? inside" do
        response = Vimeo.new("http://vimeo.com/21712912?ab")
        assert response.link =~ /\d*/
        assert response.filename.length > 0
        assert response.filename == "Shadows.flv"
        assert response.download_url.include?("token")
        assert UrlAvailable?(response.download_url)
      end
      
      should "URL with seven digits hosted on Amazon" do
        response = Vimeo.new("http://vimeo.com/2171291", :location => "/Volumes/Storage/Gems/cherrypicker/movies")
        assert response.link =~ /\d*/
        assert response.filename.length > 0
        assert response.filename == "Stephanies_Birthday__Melissa_talking_about__quot_synch_swimming_quot___and_Sheean_being_Sheean_.flv"
        assert response.location == "/Volumes/Storage/Gems/cherrypicker/movies"
        assert response.download_url.include?("AWSAccessKeyId")
        #assert UrlAvailable?(response.download_url)
      end

    end
  end
end