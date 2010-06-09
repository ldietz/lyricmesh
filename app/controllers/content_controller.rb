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
    @song = Song.find(params[:id], :include => [:album])
    @current_album = @song.album 
    @artist = @current_album.artist
    @artist_albums = @artist.albums
  end
  def comment
    Song.find(params[:id]).comments.create(params[:comment])
    flash[:notice] = "Added your comment"
    redirect_to :action => "showsong", :id => params[:id]
  end
end
