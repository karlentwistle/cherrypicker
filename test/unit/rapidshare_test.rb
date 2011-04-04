require File.dirname(__FILE__) + '/../test_helper'

class RapidshareTest < Test::Unit::TestCase
  
  context "Information request" do
         
      should "return response" do
        response = Rapidshare.new("http://rapidshare.com/files/453165880/test_file.txt", "6160038", "PXVA62ZY")
        assert response.fileid =~ /\d*/
        assert response.filename.length > 0
        assert response.hostname.length > 0
        assert !response.hostname.include?("DL: ")
      end
    
  end
  
end
