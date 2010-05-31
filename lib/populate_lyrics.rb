module PopulateLyrics  
  require 'rubygems'
  require 'nokogiri'
  require 'open-uri'
  require 'amazon/ecs'
  
  def scrape_azlyrics
    main_url = "http://azlyrics.com/"
    main_page = Nokogiri::HTML(open(main_url))
    #transverse through A-Z links on the main page.
    main_page.css(".AtoZ a").each do |letter|
      #transverse through each artist for a letter
      artists_page = Nokogiri::HTML(open(letter[:href]))
      artists_page.css("#container1 a").each do |artist|
        #only get artists whose lyrics are internal to AZLyrics
        unless artist[:rel] == 'external'
          @albums = Array.new
          @artist = Artist.create(:name => artist.content)
          #transverse through albums
          albums_page = Nokogiri::HTML(open(main_url + artist[:href]))
          albums_page.css(".Page b").each {|album| @albums << album.text}
          albums_page.css(".Page p").each do |album|
            @num += 1
            unless @albums[@num-1] == nil
              @album = Album.create(:artist_id => @artist.id, :album => @albums[@num-1], :year => "", :photo_url => "", :description => "")
              #add each song to an album
              album.css("a").each do |song|
                puts "Album Iteration: #{@num}: #{@albums[@num-1]}"
                song_album = @albums[@num - 1]
                if song_album && song[:class] != 'Ringtones'
                  #exclude songs that are linked to external sites
                  unless song[:href][/amazon/] || song[:href][/http/]
                    song_url = song[:href].gsub('..', '')
                    puts song_url
                    lyric_page = Nokogiri::HTML(open(main_url.chop + song_url))  rescue  OpenURI::HTTPError
                    #navigate through lyrics page to get lyrics
                    unless lyric_page == OpenURI::HTTPError
                      song_lyrics = lyric_page.at_css("#LyricsMainTable")
                      start_position = song_lyrics.to_s =~ /END OF RINGTONE 1/ + 24
                      end_position = song_lyrics.to_s =~ /<br><br><br><br>/
                      unless end_position == false
                        end_position -= 1
                        song_lyrics =  song_lyrics.to_s.slice!(start_position..end_position)
                        Song.create(:album_id => @album.id, :title => song.content, :lyrics => song_lyrics )	
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
  end

  def scrape_lastfm
    #initialzie generic API url strings
    generic_url = "http://ws.audioscrobbler.com/2.0/?method="
    image_append = "artist.getimages&artist="
    info_append = "artist.getinfo&artist="
    api_key = "&api_key=b25b959554ed76058ac220b7b2e0a026"
    summary_url = generic_url + "album.getinfo&api_key=b25b959554ed76058ac220b7b2e0a026&artist="
    Artist.all.each do |artist|
      #initialize artist specific API url string
      artist_sub = artist.name.gsub(" ", "+")
      image_url = generic_url + image_append  + artist.name.gsub(" ", "+") + api_key
      artist_info_url = generic_url + info_append + artist.sub + api_key
      album_info_url = summary_url + artist_sub + "&album=" + album.album.gsub(" ", "+").gsub("\"", "")
      #get artist image
      @image_pull = Nokogiri::XML(open(image_url)) rescue OpenURI::HTTPError
      if @image_pull != OpenURI::HTTPError
        if @image_pull.xpath('//size[@name="largesquare"]') != nil
          photo_url = @pull.xpath('//size[@name="largesquare"]')
          if photo_url[0] != nil
            Artist.update(artist.id, :image_url => photo_url[0].content)
          end
        end
      end
      #get artist description
      @artist_pull = Nokogiri::XML(open(artist_info_url)) rescue OpenURI::HTTPError
      if @artist_pull != OpenURI::HTTPError
        if @artist_pull.xpath('//summary') != nil and @artist_pull.xpath('//tags//name').first != nil
          artist_description = @artist_pull.xpath('//summary').text
          artist_genre = @artist_pull.xpath('//tags//name').first.text.upcase
          puts artist_genre
          artist_similar = @artist_pull.xpath('//similar//name')
          Artist.update(artist.id, :description => artist_description, :genre => artist_genre)
        end
      end
      #get album description
      artist.albums.each do |album|
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

  def scrape_amazon
    Amazon::Ecs.options = {:aWS_access_key_id => 'AKIAJAGMNKZHCOU7CBMQ',
      :aWS_secret_key => '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'}
    Album.all.each do |q|
      if q.album != nil
        #get amazon's album image/date/description
        @album_info = Amazon::Ecs.item_search((artist + q.album), {:type => 'Keywords', :response_group => 'Large', :sort => 'relevancerank', :item_page => '1', :search_index => 'Music'})
        album = @album_info.items.first
        if album != nil
          #get album cover
          photo_url = album.get('mediumimage/url')
          photo_url = "" if photo_url == nil
          #get album year
          date = album.get('releasedate').slice(0..3) if album.get('releasedate') != nil
          date = "" if date == nil
          #get album description
          album_description = album.get('editorialreview/content')
          album_description = "" if album_description == nil
          #update album with scraped data (description only if LastFM description wasn't found)
          Album.update( q.id, :photo_url => photo_url, :year => date )
          Album.update( q.id, :description => album_description ) if q.description == ""
        else
          Album.update( q.id, :photo_url => "no_pic.jpg", :year => "" )
        end
      end
    end
  end

end
