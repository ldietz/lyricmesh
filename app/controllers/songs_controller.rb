# -*- coding: utf-8 -*-
class SongsController < ApplicationController
  def index
   # @songs = Song.search(params[:search+:])
    # @artists = Song.search(params[:artist])
    @album = Album.find(Song.browse(params[:browse]).first.album_id)
    @browse = Song.browse params[:browse] 
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @artist }
    end
  end

 def search
    # @songs = Song.search(params[:search])
    # @titles = Song.title(params[:title])
    @songs = Song.search params[:search]
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @artist }
    end
  end
  
 def show
    @artists = Artist.find(Album.find(Song.find(params[:id]).album_id).artist_id)
    @albums = Album.find(Song.find(params[:id]).album_id) 
    # @songs = Song.search params[:search]
    @songs = Song.find(params[:id])

   
    respond_to do |format|
     format.html  { render (:layout => 'show_songs')} # show.html.erb
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
