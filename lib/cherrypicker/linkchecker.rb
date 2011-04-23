# Class that can query Rapidshare or Hotfile to get link 
#
# rapid = Rapidshare.new("http://rapidshare.com/files/329036215/The.Matrix.bandaa25.part06.rar", "username", "password")
# puts rapid.link
# puts rapid.fileid
# puts rapid.filename
# puts rapid.host
# rapid.download
module Cherrypicker
  class LinkChecker
    attr_accessor :links, :status

    def initialize(links)
      @links = links
      if links[0] =~ /^http(s|):\/\/(www.|)rapidshare.com/
        @status = rapidshare
      else
        @status = hotfile
      end
    end
  
    def rapidshare
      links = self.links
      files = Array.new 
      filenames = Array.new
      singlelinks = Array.new
    
      self.links.each do |link|
        files << link[/files\/(\d*)\//, 1]
        filenames << link[/files\/\d*\/(.*)/, 1]
      end

      query = "http://api.rapidshare.com/cgi-bin/rsapi.cgi?sub=checkfiles&" + 
      hash_to_url({
        :files  =>      files.join(","),
        :filenames  =>  filenames.join(","),
        :incmd5  =>     '0'
      })

      check = remote_query(query).body.split("\n")
    
      #"452966383,ROT007-WEB-2011.rar,23635847,23,1,tl2,0"  
      check.each_with_index do |c, index|
        c[/([^,]+)\,([^,]+)\,([^,]+)\,([^,]+)\,([^,]+)\,([^,]+)\,([^,]+)/]
        size = Regexp.last_match(3)
        if Regexp.last_match(5) == "1"
          status = "Alive" 
        else 
          status = "Dead"
        end
        singlelinks << SingleLink.new(links[index], "#{status}", size)
      end

      links = {}
      singlelinks.each do |a|
        links[a.status] ||= []
        links[a.status] << [a.link, a.size]
      end
      return links   
    end
  
    def hotfile
      links = self.links
      ids = Array.new 
      keys = Array.new
      singlelinks = Array.new
    
      links.each do |link|
        link[/http\:\/\/hotfile\.com\/dl\/([^\/]+)\/([^\/]+)\/([^\/]+)/]
        ids << Regexp.last_match(1)
        keys << Regexp.last_match(2)
      end
    
      query = "http://api.hotfile.com/?action=checklinks&" + 
      hash_to_url({
        :links  =>   links.join(","),
        :id  =>      ids.join(","),
        :keys  =>    keys.join(","),
        :files  =>  "id,status,size"
      })
    
      check = remote_query(query).body.split("\n")
    
      unless check.size == 0
        #"111044909,1,Playaz-Sub_Zero-PLAYAZ015-WEB-2011-EGM.rar "  
        check.each_with_index do |c, index|
          c[/([^,]+)\,([^,]+)\,([^,]+)/]
          name = Regexp.last_match(3)
          size = Regexp.last_match(1)
          if Regexp.last_match(2) == "1"
            status = "Alive"
          else
            status = "Dead"
          end
          singlelinks << SingleLink.new(links[index], "#{status}", size)
        end
      else
        links.each do |link|
          singlelinks << SingleLink.new(link, "Dead", nil)
        end
      end

      links = {}
      singlelinks.each do |a|
        links[a.status] ||= []
        links[a.status] << [a.link, a.size]
      end
      return links
    end
  end

  class SingleLink
    attr_accessor :link, :status, :size

    def initialize(link, status, size)
      @size = size
      @link = link
      @status = status
    end
  end
end