class Newmethod < ActiveRecord::Migration
  def self.up
    require 'nokogiri'
    require 'open-uri'
    doc = Nokogiri::HTML(open("http://www.azlyrics.com/c/chrisbrown.html"))
    album = doc.at_css("b").text
    artistfind = doc.css("#h1head").text
    artistfind.downcase!
    7.times do artistfind.chop! end
    artistfind.gsub!(" ", "")
    length_of_artist = artistfind.length
    albumfind = doc.css("p")
    albumfind = albumfind.to_s
    startalbum = albumfind =~ /#{artistfind}/
    startalbum = startalbum + length_of_artist
    albumfind.slice!(0..startalbum)
    startalbum = albumfind =~ /"/
    album_url = albumfind.slice!(0..startalbum-1)
       url = "http://www.azlyrics.com/lyrics/" + artistfind + "/" + album_url
        doc2 = Nokogiri::HTML(open(url))
        title = doc2.at_css("#h1lyrhead").text
        8.times do title.chop! end
        title = title.slice(1..40)
        artist = doc2.at_css(".ArtistTitle").text
        7.times do artist.chop! end
        lyrics = doc2.at_css("#LyricsMainTable").to_s
        start_position = lyrics =~ /END OF RINGTONE 1/
        start_position = start_position +24
        end_position = lyrics =~ /<br><br><br><br>/
        end_position = end_position -1
        lyrics =  lyrics.slice!(start_position..end_position)
                 Lyric.create(:title => title,
                 :artist => artist,
                 :album => album,
                 :year => "ba",
                 :lyrics => lyrics,
                 :image_url => "ba" )
  end

  def self.down
  end
end
