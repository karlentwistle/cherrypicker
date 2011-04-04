# Class that can sort Hotfile link into sections as specified by Hotfile API 
#
# hotfile = Hotfile.new("http://hotfile.com/dl/110589431/6ad2666/ROT007-WEB-2011.rar.html", "username", "password")
# puts hotfile.link
# puts hotfile.hostname
# hotfile.download
class Hotfile
  attr_accessor :link, :hostname, :filename, :username, :password, :size

  def initialize(link, username, password, size = nil)
    if link =~ /hotfile.com\/dl\/\d*\/[0-9a-f]*\/.*.*\.html/
      @link = link[/(.*)\.html/, 1]
    else
      @link = link
    end
    @username = username
    @password = password
    @hostname = hostname
    @filename = filename
    @size     = size
  end

  def download
    Download.new(self.hostname, remote_url, self.filename, self.size)
  end
  
  def filename
    self.link[/dl\/\d*\/[0-9a-f]*\/(.*)/, 1]
  end
  
  def create_url
    hash_to_url({
      :link  =>  self.link,
      :username  =>  self.username.to_s,
      :password  =>  self.password.to_s
    })
  end
  
  def request
    query = remote_query("http://api.hotfile.com/?action=getdirectdownloadlink&" + create_url)
    query.response.body
  end
  
  def hostname   
    "#{request[/http:\/\/(.*).hotfile.com/, 1]}" + ".hotfile.com"
  end
  
  def remote_url   
    "#{request[/http:\/\/.*.hotfile.com(.*)/, 1]}"
  end
end