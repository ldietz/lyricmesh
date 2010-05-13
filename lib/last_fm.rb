module LastFm
require 'rubygems'
require 'nokogiri'
require 'open-uri'

def lastscrape
  generic_url = "http://ws.audioscrobbler.com/2.0/?method=artist.getimages&artist="
  api_key = "&api_key=b25b959554ed76058ac220b7b2e0a026"
  generic_info_url = "http://ws.audioscrobbler.com/2.0/?method=artist.getinfo&artist="
  generic_artist_summary_url = "http://ws.audioscrobbler.com/2.0/?method=album.getinfo&api_key=b25b959554ed76058ac220b7b2e0a026&artist="
  Artist.all.each do |artist|
    search_image_url = generic_url + artist.name.gsub(" ", "+") + api_key
    search_info_url = generic_info_url + artist.name.gsub(" ", "+") + api_key
    @pull = Nokogiri::XML(open(search_image_url)) rescue OpenURI::HTTPError
    puts "1"
    puts @pull
    if @pull != OpenURI::HTTPError
      if @pull.xpath('//size[@name="largesquare"]') != nil
        photo_url = @pull.xpath('//size[@name="largesquare"]')
        if photo_url[0] != nil
          Artist.update(artist.id, :image_url => photo_url[0].content)
        end
      end
    end
    @pull2 = Nokogiri::XML(open(search_info_url)) rescue OpenURI::HTTPError
    puts "2"
    if @pull2 != OpenURI::HTTPError
      if @pull2.xpath('//summary') != nil and @pull2.xpath('//tags//name').first != nil
        artist_description = @pull2.xpath('//summary').text
        artist_genre = @pull2.xpath('//tags//name').first.text.upcase
        puts artist_genre
        artist_similar = @pull2.xpath('//similar//name')
        Artist.update(artist.id, :description => artist_description, :genre => artist_genre)
      end
    end
    artist.albums.each do |album|
      search_album_description_url = generic_artist_summary_url + artist.name.gsub(" ", "+") + "&album=" + album.album.gsub(" ", "+").gsub("\"", "")
      @pull3 = Nokogiri::XML(open(search_album_description_url)) rescue OpenURI::HTTPError
      puts "3"
      if @pull3 != OpenURI::HTTPError
        if @pull3.xpath('//summary') != nil
          artist_summary = @pull3.xpath('//summary').text
          Album.update(album.id, :description => artist_summary)
        end
      end
    end
  end
end
end


  


