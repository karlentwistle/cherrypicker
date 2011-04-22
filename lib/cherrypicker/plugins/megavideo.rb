# Class that can download from Vimeo
# Megavideo.new("http://www.megavideo.com/?v=2PEKD0YS", :location => "/Volumes/Storage/Desktop/cherrytest/").download

require 'open-uri'

class Megavideo
  attr_accessor :link, :filename, :location, :download_url

  def initialize(link, opts={})
    o = {
      :location => nil,
    }.merge(opts)
    
    @link         = link
    @filename     = ""
    @location     = o[:location]
    @download_url = ""
    @size         = 0
    
    video_id = @link[/v[\/=](\w*)&?/, 1]
    
    #credit http://stackoverflow.com/questions/5748876/build-array-of-flashvars-using-hpricot
    html = open("http://megavideo.com/?v=#{video_id}").read
    flashvars = Hash[ html.scan( /flashvars\.(\w+)\s*=\s*["']?(.+?)["']?;/ ) ]

    key_s =  flashvars["s"]
    key_un = flashvars["un"]
    key_k1 = flashvars["k1"]
    key_k2 = flashvars["k2"]
    
		title = flashvars["title"]
		@size = flashvars["size"].to_i * 1024 * 1024

		@download_url = "http://www#{key_s}.megavideo.com/files/#{decrypt(key_un,key_k1,key_k2)}/#{title}.flv"
		@filename = title + ".flv"
  end
    
  def decrypt(un,k1,k2) #credit http://userscripts.org/scripts/review/42944
    k1 = k1.to_i
    k2 = k2.to_i

    #convert the hex "un" to binary
    location1 = Array.new
    un.each_char do |char|
      #puts "#{char} => #{char.to_i(16).to_s(2)}"
      location1 << ("000" + char.to_i(16).to_s(2))[-4,4]
    end

    location1 = location1.join("").split("")

    location6 = Array.new
    0.upto(383) do |n|
      k1 = (k1 * 11 + 77213) % 81371
      k2 = (k2 * 17 + 92717) % 192811
      location6[n] = (k1 + k2) % 128
    end

    location3 = Array.new
    location4 = Array.new
    location5 = Array.new
    location8 = Array.new

    256.downto(0) do |n|
      location5 = location6[n]
      location4 = n % 128		
      location8 = location1[location5]
      location1[location5] = location1[location4]
      location1[location4] = location8
    end

    0.upto(127) do |n|
      location1[n] = location1[n].to_i ^ location6[n+256] & 1
    end

    location12 = location1.join("")
    location7 = Array.new

    n = 0
    while (n < location12.length) do
      location9 = location12[n,4]
      location7 << location9
      n+=4
    end

    result = ""
    location7.each do |bin|
      result = result + bin.to_i(2).to_s(16)
    end
    result
  end
    
  def download
    Download.new(@download_url, :location => @location, :size => @size)
  end
end