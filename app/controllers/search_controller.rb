class SearchController < ApplicationController
  def index
    @top_artists = Artist.search_top()
    @top_songs = Song.find_top_songs()
  end

  def browsegenres
    @artists = Artist.find(:all)
  end

  def showgenres
    @artists = Artist.search_genre(params[:genre])
  end

  def results
    @artists = Artist.search params[:q] if params[:type] == 'artist'
    @songs = Song.search(params[:q]) if params[:type] == 'song'
  end  
end

