class SearchController < ApplicationController
  def index
    @artists_all =  Artist.find(:all)
    @artists = Artist.search params[:q] if params[:type] == 'artist'
    @albums = Album.find(:all)
    # @current_artist = Artist.find(Album.find(Song.search(params[:q]).album_id).artist_id)
    # @current_album = Album.find(Song.search(params[:q]).album_id)
    @songs = Song.search(params[:q]) if params[:type] == 'song'
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @artist }
    end
  end

  def show
    @songs = Song.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @artist }
    end
  end

  def new
    @artist = Artist.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @artist }
    end
  end

  def edit
    @artist = Artist.find(params[:id])
  end


  def browsegenres
    @artists = Artist.find(:all)
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @artist }
    end
  end

  def showgenres
    @artists = Artist.search_genre(params[:genre])
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @artist }
    end
  end

  def results
    @artists_all =  Artist.find(:all)
    @artists = Artist.search params[:q] if params[:type] == 'artist'
    @albums = Album.find(:all)
    # @current_artist = Artist.find(Album.find(Song.search(params[:q]).album_id).artist_id)
    # @current_album = Album.find(Song.search(params[:q]).album_id)
    @songs = Song.search(params[:q]) if params[:type] == 'song'
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @artist }
    end
  end
  
end

