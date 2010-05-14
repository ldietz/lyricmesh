class GenreController < ApplicationController
  def index
    @pop = Artist.search_genre(params[:genre])
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @artist }
    end
  end
  def show
    @artists = Artist.search_genre(params[:genre])
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @artist }
    end
  end
end
