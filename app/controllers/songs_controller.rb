class SongsController < ApplicationController
<<<<<<< HEAD:app/controllers/songs_controller.rb
  def index
   # @songs = Song.search(params[:search+:])
   # @artists = Song.search(params[:artist])
   @browse = Song.browse params[:browse]
=======
  def index    
    @browse = Song.browse params[:browse]
>>>>>>> c53f437ddbf17a0dded5f3ee6b3f468014902e7e:app/controllers/songs_controller.rb
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
    @artists = Artist.find(:all)
    @albums = Album.find(:all) 
    # @songs = Song.search params[:search]
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
