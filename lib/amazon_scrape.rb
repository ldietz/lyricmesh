module AmazonScrape
require 'amazon/ecs'

Amazon::Ecs.options = {:aWS_access_key_id => 'AKIAJAGMNKZHCOU7CBMQ',
  :aWS_secret_key => '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'}

Album.all.each do |q|
    puts q
    artist = Artist.find(q.artist_id).name
    puts artist
  if q.album != nil
    query = artist + q.album
    puts query
    @pull = Amazon::Ecs.item_search(query, {:type => 'Keywords', :response_group => 'Large', :sort => 'relevancerank', :item_page => '1', :search_index => 'Music'})
    @pull2 = Amazon::Ecs.item_search(artist, {:type => 'Keywords', :response_group => 'Subjects', :sort => 'relevancerank', :item_page => '1', :search_index => 'Music'})
    puts "after pull"
    # title = @pull.items.first.get('title')
    # price = @pull.items.first.get('formattedprice')
    if @pull.items.first != nil 
      url = @pull.items.first.get('mediumimage/url')
      puts url
      date = @pull.items.first.get('releasedate').slice(0..3)
      album_description = @pull.items.first.get('editorialreview/content')
      artist_genre = @pull2.items.first.get_array('subject')
      if artist_genre[0].to_f.to_s == "0.0"; genre = artist_genre[0]; else genre = artist_genre[1] end
      #artist_description = @pull2.items.first.get('')
      Album.update( q.id, :photo_url => url, :year => date, :description => album_description )
      Artist.update( q.artist_id, :genre => genre )  
    else
      Album.update( q.id, :photo_url => "no_pic.jpg" )
    end
  end
end
end


