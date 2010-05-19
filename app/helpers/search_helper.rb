module SearchHelper
  def initialize_current(song)
    @current_album = Album.find(song.album_id)
    @current_artist = Artist.find(Album.find(song.album_id).artist_id)
    @count = (@current_album.songs.count)
    @cd_cover =  "../content/albumsongs?browse="
  end

  def print_song_suggestion(songs)
    if params[:q] != songs.suggestion
      link_to( songs.suggestion, "../search/results?q="+@songs.suggestion+"&type=song")
    end
  end

  def search_url(start, stop, album, artist)
    @url = Array.new
    @url_title = Array.new
    @a = 0
    for num in start..stop
      @url_title[@a] = "#{album.songs[num].title}"
      @url[@a] = "../content/showsong?id=#{album.songs[num].id}&album=#{artist.id}"
      @a += 1
    end
  end

  def print_suggestion
    if params[:q] != @artists.suggestion
      link_to( @artists.suggestion, "../search/results?q="+@artists.suggestion+"&type=artist")
    end
  end

  def did_you_mean(suggestion)
    if params[:q] != suggestion
      simple_format("did you mean")
    end
  end

  def display_mainpage(num)
    @counter = 0
    @num_artist_found = 0
    @kill_while = 0
    while( @kill_while == 0 )
      @find_artist = Artist.find(:all, :conditions =>{:name =>@top_artists[@counter]})
      if @find_artist != nil and @find_artist.first != nil
        if @num_artist_found == num
          @artist_name = @find_artist.first.name
          image_tag( @find_artist.first.image_url,  :size =>"100x100" )
          @kill_while = 1
        else
          @num_artist_found += 1
        end
      else
        @kill_while = 0
        @counter += 1
      end
    end
  end
end
