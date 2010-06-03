module SearchHelper
  require 'rubygems'
  require 'nokogiri'
  require 'open-uri'


  # get current song information
  def initialize_current(song)
    @current_album = song.album
    @current_artist = @current_album.artist
    @count = (@current_album.songs.count)
    @cd_cover =  "../content/albumsongs?browse="
  end

  # form url to artist
  def search_url(start, stop, album, artist)
    @url = Array.new, @url_title = Array.new, a = 0
    for num in start..stop
      @url_title[a] = "#{album.songs[num].title}"
      @url[a] = "../content/showsong?id=#{album.songs[num].id}&album=#{artist.id}"
      a += 1
    end
  end

  # spelling suggestion helpers
  def did_you_mean(suggestion)
    if params[:q] != suggestion
      simple_format("did you mean")
    end
  end
  
  def artist_suggestion
    if params[:q] != @artists.suggestion
      link_to( @artists.suggestion, "../search/results?q="+@artists.suggestion+"&type=artist")
    end
  end

  def song_suggestion(songs)
    if params[:q] != songs.suggestion
      link_to( songs.suggestion, "../search/results?q="+@songs.suggestion+"&type=song")
    end
  end
 
  # homepage helpers
  def top_artists(find_artist)
    @top = Hash.new
    @top[:names], @top[:images], @top[:covers] = ["","",""],["","",""],["","",""]
    10.times do |i|
      artist = Artist.first(:conditions =>{:name => @top_artists[i]})
      unless artist == nil
        @top[:names] << artist.name
        @top[:images] << artist.image_url
        @top[:covers] << "../content/albums?album="+@find_artist.first.id.to_s
      end
    end
  end
  
  # helpers for browsegenres
  def gather_genres
    @genres = []
    Artist.all.each do |artist|
      @genres << artist.genre if @genres.include?(artist.genre) == false and artist.genre != nil
    end
    @genres.sort!
    @total_genres = @genres.count
    @genre_url = "../search/showgenres?genre="
  end
end
