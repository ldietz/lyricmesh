module Scraper  
  require 'rubygems'
  require 'nokogiri'
  require 'open-uri'
  
  class AzLyrics
    attr_accessor :albums, :artists, :songs
    
    @main_url = "http://azlyrics.com/"
    @main_page = Nokogiri::HTML(open(@main_url))
    
    def self.start
      get_alphabet 
      get_artists
      @artists.each do |@artist_pull|      
        unless @artist_pull[:rel] == 'external'
          create_artist
          get_albums
          @num = 0
          @albums_page.css(".Page p").each do |@album_pull|
            @num += 1
            unless @albums[@num-1] == nil
              create_album
              get_songs
            end
          end
        end
      end
    end
    
    def self.get_alphabet
      @letter = []
      @main_page.css(".AtoZ a").each do |letter|
        @letter << letter
      end      
    end
    
    def self.get_artists
      @artists = []
      @letter.each do |letter|
        artists_page = Nokogiri::HTML(open(letter[:href])) 
        artists_page.css("#container1 a").each do |artist|
          @artists << artist
        end
      end   
    end
    
    def self.create_artist
      @albums = []
      @artist = Artist.create(:name => @artist_pull.content)
    end

    def self.get_albums
      @albums_page = Nokogiri::HTML(open(@main_url + @artist_pull[:href]))
      @albums_page.css(".Page b").each {|album| @albums << album.text}
    end

    def self.create_album
      @album = Album.create(:artist_id => @artist.id, :album => @albums[@num-1], :year => "", :photo_url => "", :description => "")
    end
    
    def self.get_songs
      puts "got to songs"
      @album_pull.css("a").each do |@song|
        puts "Album Iteration: #{@num}: #{@albums[@num-1]}"
        song_album = @albums[@num - 1]
        if song_album && @song[:class] != 'Ringtones'
          #exclude songs that are linked to external sites
          unless @song[:href][/amazon/] || @song[:href][/http/]
            song_url = @song[:href].gsub('..', '')
            puts song_url
            @lyric_page = Nokogiri::HTML(open(@main_url.chop + song_url))  rescue  OpenURI::HTTPError
            get_lyrics
          end
        end
      end
    end
    
    def self.get_lyrics
      unless @lyric_page == OpenURI::HTTPError
        song_lyrics = @lyric_page.at_css("#LyricsMainTable")
        start_position = song_lyrics.to_s =~ /END OF RINGTONE 1/
        start_position += 24
        end_position = song_lyrics.to_s =~ /<br><br><br><br>/
        unless end_position == false
          end_position -= 1
          song_lyrics =  song_lyrics.to_s.slice!(start_position..end_position)
          Song.create(:album_id => @album.id, :title => @song.content, :lyrics => song_lyrics )
        end
      end
    end
  end

  class LastFm
    #attr_accessor
    
    @generic_url = "http://ws.audioscrobbler.com/2.0/?method="
    @image_append = "artist.getimages&artist="
    @info_append = "artist.getinfo&artist="
    @api_key = "&api_key="
    @summary_url = @generic_url + "album.getinfo&api_key=6&artist="
    
    def self.start
      Artist.all.each do |@artist|
        initialize_strings
        get_artist
        get_artist_description
        get_album_description
      end
    end
    
    def self.initialize_strings
      @artist_sub = @artist.name.gsub(" ", "+")
      @image_url = @generic_url + @image_append  + @artist.name.gsub(" ", "+") + @api_key
      @artist_info_url = @generic_url + @info_append + @artist_sub + @api_key
    end

    def self.get_artist
      @image_pull = Nokogiri::XML(open(@image_url)) rescue OpenURI::HTTPError
      if @image_pull != OpenURI::HTTPError
        if @image_pull.xpath('//size[@name="largesquare"]') != nil
          photo_url = @image_pull.xpath('//size[@name="largesquare"]')
          if photo_url[0] != nil
            Artist.update(@artist.id, :image_url => photo_url[0].content)
          end
        end
      end
    end
    
    def self.get_artist_description
      @artist_pull = Nokogiri::XML(open(@artist_info_url)) rescue OpenURI::HTTPError
      if @artist_pull != OpenURI::HTTPError
        if @artist_pull.xpath('//summary') != nil and @artist_pull.xpath('//tags//name').first != nil
          artist_description = @artist_pull.xpath('//summary').text
          artist_genre = @artist_pull.xpath('//tags//name').first.text.upcase
          puts artist_genre
          artist_similar = @artist_pull.xpath('//similar//name')
          Artist.update(@artist.id, :description => artist_description, :genre => artist_genre)
        end
      end
    end
    
    def self.get_album_description
      @artist.albums.each do |album|
        album_info_url = @summary_url + @artist_sub + "&album=" + album.album.gsub(" ", "+").gsub("\"", "")
        @album_pull = Nokogiri::XML(open(album_info_url)) rescue OpenURI::HTTPError
        if @album_pull != OpenURI::HTTPError
          if @album_pull.xpath('//summary') != nil
            artist_summary = @album_pull.xpath('//summary').text
            Album.update(album.id, :description => artist_summary)
          end
        end
      end
    end
  end

  class AmazonOnline
    require 'amazon/ecs'
    attr_accessor

    def self.start
      Amazon::Ecs.options = {:aWS_access_key_id => '',
        :aWS_secret_key => ''}
      Album.all.each do |@q|
        if @q.album != nil
          search_album
          if @album != nil
            get_cover
            get_year
            get_description
            update_album
          else
            Album.update( @q.id, :photo_url => "no_pic.jpg", :year => "" )
          end
        end
      end
    end
    
    def self.search_album
      artist = Artist.find(@q.artist_id).name
      @album_info = Amazon::Ecs.item_search((artist + @q.album), {:type => 'Keywords', :response_group => 'Large', :sort => 'relevancerank', :item_page => '1', :search_index => 'Music'})
      @album = @album_info.items.first
    end
    
    def self.get_cover
      @photo_url = @album.get('mediumimage/url')
      @photo_url = "" if @photo_url == nil
    end
    
    def self.get_year
      @date = @album.get('releasedate').slice(0..3) if @album.get('releasedate') != nil
      @date = "" if @date == nil
    end
    
    def self.get_description
      @album_description = @album.get('editorialreview/content')
      @album_description = "" if @album_description == nil
    end
    
    def self.update_album
      Album.update( @q.id, :photo_url => @photo_url, :year => @date )
      Album.update( @q.id, :description => @album_description ) if @q.description == ""
    end  
  end

end
