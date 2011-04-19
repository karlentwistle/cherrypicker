# Class that can sort Rapidshare link into sections as specified by RapidShare API 
#
# rapid = Rapidshare.new("http://rapidshare.com/files/329036215/The.Matrix.bandaa25.part06.rar", "username", "password")
# puts rapid.link
# puts rapid.fileid
# puts rapid.filename
# puts rapid.host
# rapid.download
class Rapidshare
  attr_accessor :link, :fileid, :filename, :hostname, :username, :password, :size, :location

  def initialize(link, username, password, size = nil, location = "")
    @link     = link
    @fileid   = fileid
    @filename = filename
 #   @hostname = hostname
    @username = username
    @password = password
    @size     = size
    @location = location
  end
  
  def download
    Download.new(self.hostname, remote_url, self.filename, self.size, self.location)
  end
  
  def fileid
    self.link[/files\/(\d*)\//, 1]
  end
  
  def filename
    self.link[/files\/\d*\/(.*)/, 1]
  end
  
  def remote_url
    "/cgi-bin/rsapi.cgi?sub=download&" + create_url
  end
    
  def create_url
   hash_to_url({
      :fileid  =>   self.fileid,
      :filename  => self.filename,
      :login  =>    self.username.to_s,
      :password  => self.password.to_s
    })
  end
  
  def hostname
    query = remote_query("http://api.rapidshare.com/cgi-bin/rsapi.cgi?sub=download&" + create_url)
    query.response.response["Location"][/https:\/\/(.*).rapidshare.com/, 1] + ".rapidshare.com"
  end  
end