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

  def display_mainpage(find_artist)
    @counter = 0
    @num_artist_found = 0
    @kill_while = 0
    @top_three = Array.new
    while(@kill_while == 0)
      @find_artist = Artist.find(:all, :conditions =>{:name =>"A-ha"})
      if @find_artist != [] and @find_artist.first != nil
        @top_three[@num_artist_found] = @find_artist.first.name
        @counter += 1
        if @num_artist_found != 2
          @num_artist_found += 1
        else
          @kill_while = 1
        end
      else
        @kill_while = 0
        @counter += 1
        if(@counter == 10)
          @kill_while = 1
        end
      end
    end
    return @top_three
  end
end
