class Albumworking2 < ActiveRecord::Migration
  def self.up
    require 'nokogiri'
    require 'open-uri'
    doc = Nokogiri::HTML(open("http://www.azlyrics.com/g/garbage.html"))
    album = doc.css("b").text
    albumfind = doc.css("p")
    albumfind = albumfind.to_s
    artistfind = doc.css("#h1head").text
    artistfind.downcase!
    7.times do artistfind.chop! end
    artistfind.gsub!(" ", "")
    artistfind.gsub!(/[&-]/, "")
    puts artistfind
    length_of_artist = artistfind.length
  while album != nil do  
    album = album.slice(1..200)
    puts "a"
    nextalbum = album =~ /"/
    puts "b"
    puts album
    puts nextalbum
    if nextalbum == false
      break
    end
    currentalbum = album.slice!(0..nextalbum)
    puts "c"
    currentalbum.chop!
    puts "d"

    next_album_position = albumfind =~ /album/
    if next_album_position == nil
      next_album_position = 10000
    end
    startalbum = albumfind =~ /#{artistfind}/
    puts next_album_position
    puts startalbum
    puts currentalbum
    if next_album_position < startalbum and next_album_position != nil
      to_next_p = albumfind =~ /<p>/
      albumfind.slice!(0..to_next_p)
      next_album_position = albumfind =~ /album/
      startalbum = albumfind =~ /#{artistfind}/
      puts next_album_position
      if next_album_position == nil
        next_album_position = 10000
      end
    end
    while next_album_position > startalbum
      puts "past while"
      startalbum = startalbum + length_of_artist
      albumfind.slice!(0..startalbum)
      startalbum = albumfind =~ /"/
      album_url = albumfind.slice!(0..startalbum-1)
      puts album_url
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
                   :album => currentalbum,
                   :year => "",
                   :lyrics => lyrics,
                   :image_url => "" )
      next_album_position = albumfind =~ /album/
      if next_album_position == nil
        next_album_position = 10000
      end
      startalbum = albumfind =~ /#{artistfind}/
      if startalbum == nil
        puts album
        break
      end
    end
  end
  end

  def self.down
  end
end
