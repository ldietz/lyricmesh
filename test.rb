    require 'rubygems'
    require 'nokogiri'
    require 'open-uri'
    doc = Nokogiri::HTML(open("http://www.azlyrics.com/c/chrisbrown.html"))
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
    puts albumfind
    startalbum = albumfind =~ /"/
    puts startalbum
    album_url = albumfind.slice!(0..startalbum-1)
    url = "http://www.azlyrics.com/lyrics/" + artistfind + "/" + album_url
    puts url
        doc2 = Nokogiri::HTML(open(url))
        title = doc2.at_css("#h1lyrhead").text
        8.times do title.chop! end
    title = title.slice(1..40)
        artist = doc2.at_css(".ArtistTitle").text
    7.times do artist.chop! end
    puts artist
