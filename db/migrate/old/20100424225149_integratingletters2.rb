class Integratingletters2 < ActiveRecord::Migration
  def self.up
        require 'nokogiri'
    require 'open-uri'

#doc3 = Nokogiri::HTML(open("http://www.azlyrics.com/d.html"))
#col1 = doc3.css("#col1")
#col1 = col1.to_s
#while 1
 # startlink = col1 =~ /href/
 # if startlink != nil
    #col1.slice!(0..startlink-1)
    #if col1.slice(7..7) == "/"
    #  col1.slice!(0..7)
    #  endlink = col1 =~ /"/
    #  link = col1.slice!(0..endlink-1)
    #  puts link


    first_time = nil
    soundtrackyes = nil
      doc = Nokogiri::HTML(open("http://www.azlyrics.com/d/damianmarley.html"))
    album = doc.css("b").text
    albumfind = doc.css("p")
    albumfind = albumfind.to_s
    artistfind = doc.css("#h1head").text
    artistfind.downcase!
    7.times do artistfind.chop! end
    artistfind.gsub!(" ", "")
    artistfind.gsub!(/[&-]/, "")
    artistfind.gsub!(/'/, "")  
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
    if soundtrackyes != nil
      next_album_position = albumfind =~ /soundtrack/
    else
      next_album_position = albumfind =~ /album/
    end
    if next_album_position == nil and soundtrackyes == nil
      next_album_position = 10000
    end
    startalbum = albumfind =~ /#{artistfind}/
    if startalbum == nil
      break
    end
    puts next_album_position
    if next_album_position < startalbum and next_album_position != nil
      to_next_p = albumfind =~ /<p>/
      albumfind.slice!(0..to_next_p)
      if soundtrackyes != nil
        next_album_position = albumfind =~ /soundtrack/
      else
        next_album_position = albumfind =~ /album/
      end
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
      puts next_album_position
      if next_album_position == nil
        next_album_position = 10000
        check_for_comp =  albumfind =~ /compilation/
        puts check_for_comp
        if check_for_comp != nil
          next_album_find = check_for_comp
          puts next_album_find
           startalbum2 = albumfind =~ /#{artistfind}/
          if next_album_find < startalbum2
            next_album_position = 0
          end
        end
      end
      puts "past if"
      
      check_for_sound =  albumfind =~ /soundtrack/
     # puts check_for_sound
     # if check_for_sound != nil
       # next_album_find = check_for_sound
       # puts next_album_find
       # startalbum3 = albumfind =~ /#{artistfind}/
       # if next_album_find < startalbum3
        #  next_album_position = 0
       # end
      #end
      soundtrackyes = nil
      startalbum = albumfind =~ /#{artistfind}/
      puts startalbum
      puts check_for_sound
      if check_for_sound != nil
        if startalbum > check_for_sound
          soundtrackyes = 1
          puts first_time
          if first_time == nil
            next_album_position = 0
            first_time = 1
          end
        end
      end
      puts "just before startalbum"
      if startalbum == nil
        puts album
        break
      end
    end
  end


#    else
#      col1.slice!(0..3)
#    end
#  end
#end

      
  end

  def self.down
  end
end
