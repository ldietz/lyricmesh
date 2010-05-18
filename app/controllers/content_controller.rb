class ContentController < ApplicationController
  def artists
    @artists = Artist.search_name(params[:artist])
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @artist }
    end
  end

  def albums
    @artist = Artist.find(Album.search_title(params[:album]).first.artist_id)
    @albums = Album.search_title(params[:album])
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @artist }
    end
  end

  def albumsongs
    @artist = Artist.find(Album.find(Song.browse(params[:browse]).first.album_id).artist_id)
    @album = Album.find(Song.browse(params[:browse]).first.album_id)
    @browse = Song.browse params[:browse] 
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @artist }
    end
  end

   def showsong
    @artists = Artist.find(Album.find(Song.find(params[:id]).album_id).artist_id)
    @current_album = Album.find(Song.find(params[:id]).album_id) 
    @songs = Song.find(params[:id])
    @albums = Album.search_title(params[:album])
   
    respond_to do |format|
     format.html  { render (:layout => 'show_songs')} # show.html.erb
      format.xml  { render :xml => @artist }
    end
  end
    
end
