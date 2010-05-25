class ContentController < ApplicationController
  def artists
    @artists = Artist.search_name(params[:artist])
  end

  def albums
    @albums = Album.search_title(params[:album])
    @artist = @albums.first.artist

  end

  def albumsongs
    @album = Album.find(params[:browse], :include => [:songs])
    @songs = @album.songs 
  end

  def showsong
    @songs = Song.find(params[:id], :include => [:album])
    @current_album = @songs.album 
    @artist = @current_album.artist
    @artist_albums = @artist.albums
  end
end
