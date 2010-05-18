module GenreHelper
  def gather_genres
    @genres = Array.new
    Artist.all.each do |artist|
      @add_new_genre = 1
      @genres.each do |genre|
        if genre == artist.genre
          @add_new_genre = 0
        end
      end
      if @add_new_genre == 1 and artist.genre != nil
        genre_array = [artist.genre]
        @genres = @genres.concat(genre_array)
      end
    end
    @genres.sort!
    @count = @genres.count
    @genre_url = "../search/showgenres?genre="
  end
end
