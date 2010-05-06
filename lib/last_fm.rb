
require 'rubygems'
require 'nokogiri'
require 'open-uri'


generic_url = "http://ws.audioscrobbler.com/2.0/?method=artist.getimages&artist="
api_key = "&api_key=b25b959554ed76058ac220b7b2e0a026"
Artist.all.each do |artist|
  search_image_url = generic_url + artist.name + api_key
  puts search_image_url
  @pull = Nokogiri::XML(open(search_image_url))
  photo_url = @pull.xpath('//size[@name="largesquare"]')
  Artist.update(artist.id, :image_url => photo_url[0].content)
end


