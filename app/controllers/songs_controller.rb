# -*- coding: utf-8 -*-
class SongsController < ApplicationController
  def index
   # @songs = Song.search(params[:search+:])
    # @artists = Song.search(params[:artist])
    @artist = Artist.find(Album.find(Song.find(params[:id]).album_id).artist_id)
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
    @current_album = Album.find(Song.find(params[:id]).album_id) 
    # @songs = Song.search params[:search]
    @songs = Song.find(params[:id])
    @albums = Album.search_title(params[:album])
   
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
