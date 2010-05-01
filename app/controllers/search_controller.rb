class SearchController < ApplicationController
  def index
    @artists_all =  Artist.find(:all)
    @artists = Artist.search params[:q] if params[:type] == 'artist'
    @albums = Album.find(:all)
    @songs = Song.search params[:q] if params[:type] == 'song'
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

end
