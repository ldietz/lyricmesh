class LyricsController < ApplicationController


  # GET /lyrics
  # GET /lyrics.xml
  def index
  #  @lyrics = Lyric.search(params[:search])
  #  @artists = Lyric.artistsearch(params[:artistsearch])
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @lyrics }
    end
  end

 def video
    @lyrics = Lyric.search(params[:search])
    @artists = Lyric.artistsearch(params[:artistsearch])
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @lyrics }
    end
  end
  
  def search
    @lyrics = Lyric.search(params[:search])
    @artists = Lyric.artistsearch(params[:artistsearch])
    @albums = Lyric.albumsearch(params[:albumsearch])
    @titles = Lyric.titlesearch(params[:titlesearch])
    @artistsall = Lyric.searchall(params[:searchall])
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @lyrics }
    end
  end
  def artistsearch
    @lyrics = Song.search_title(params[:search])
    @artists = Artist.search_name(params[:search])
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @lyrics }
    end
  end

  
  def artist
    @lyrics = Song.search_title(params[:search])
    @artists = Artist.search_name(params[:search])
    @albums = Album.search_title(params[:search])
    @artistsall = Lyric.searchall(params[:searchall])
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @lyrics }
    end
  end
    
  def album
    @lyrics = Lyric.search(params[:search])
    @artists = Lyric.artistsearch(params[:artistsearch])
    @albums = Lyric.albumsearch(params[:albumsearch])
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @lyrics }
    end
  end

 def title
   @lyrics = Lyric.search(params[:search])
   @artists = Lyric.artistsearch(params[:artistsearch])
   @titles = Lyric.titlesearch(params[:titlesearch])
   respond_to do |format|
     format.html # index.html.erb
     format.xml  { render :xml => @lyrics }
   end
 end
  
  # GET /lyrics/1
  # GET /lyrics/1.xml
  def show
    @lyric = Lyric.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @lyric }
    end
  end

  # GET /lyrics/new
  # GET /lyrics/new.xml
  def new
    @lyric = Lyric.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @lyric }
    end
  end

  # GET /lyrics/1/edit
  def edit
    @lyric = Lyric.find(params[:id])
  end
  # POST /lyrics
  # POST /lyrics.xml
  def create
    @lyric = Lyric.new(params[:lyric])

    respond_to do |format|
      if @lyric.save
        flash[:notice] = 'Lyric was successfully created.'
        format.html { redirect_to(@lyric) }
        format.xml  { render :xml => @lyric, :status => :created, :location => @lyric }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @lyric.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /lyrics/1
  # PUT /lyrics/1.xml
  def update
    @lyric = Lyric.find(params[:id])

    respond_to do |format|
      if @lyric.update_attributes(params[:lyric])
        flash[:notice] = 'Lyric was successfully updated.'
        format.html { redirect_to(@lyric) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @lyric.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /lyrics/1
  # DELETE /lyrics/1.xml
  def destroy
    @lyric = Lyric.find(params[:id])
    @lyric.destroy

    respond_to do |format|
      format.html { redirect_to(lyrics_url) }
      format.xml  { head :ok }
    end
  end
end
