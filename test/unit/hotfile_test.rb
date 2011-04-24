require File.dirname(__FILE__) + '/../test_helper'

class HotfileTest < Test::Unit::TestCase
  
  context "Information request" do
         
      should "return response" do
        response = Hotfile.new("http://hotfile.com/dl/110752208/b0cb939/test_file.txt.html", "username", "password")
        assert response.filename.length > 0
        assert response.hostname[/(.*)\.hotfile.com/, 1].length > 0
      end
    
  end
  
end