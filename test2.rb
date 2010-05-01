require 'rubygems'
require 'nokogiri'
require 'open-uri'
doc3 = Nokogiri::HTML(open("http://www.azlyrics.com/d.html"))
col1 = doc3.css("#col1")
col1 = col1.to_s
col2 = doc3.css("#col2")
col2 = col2.to_s
while 1
  startlink = col1 =~ /href/
  if startlink != nil
    col1.slice!(0..startlink-1)
    if col1.slice(7..7) == "/"
      col1.slice!(0..7)
      endlink = col1 =~ /"/
      link = col1.slice!(0..endlink-1)
      puts link
    else
      col1.slice!(0..3)
    end
    if startlink == nil
      
  end
end
