module AmazonScrape
require 'amazon/ecs'
def amascrape
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
        if @pull.items.first.get('mediumimage/url') != nil
          url = @pull.items.first.get('mediumimage/url')
        else url = ""
        end
        puts url
        if @pull.items.first.get('releasedate') != nil
          date = @pull.items.first.get('releasedate').slice(0..3)
        else date = ""
        end
        if @pull.items.first.get('editorialreview/content') != nil
          album_description = @pull.items.first.get('editorialreview/content')
        else album_description = ""
        end  
        #artist_description = @pull2.items.first.get('')
        Album.update( q.id, :photo_url => url, :year => date )
        if q.description == ""
          Album.update( q.id, :description => album_description )
        end
      else
        Album.update( q.id, :photo_url => "no_pic.jpg" )
      end
    end
  end
end
end




#    @pull2 = Amazon::Ecs.item_search(artist, {:type => 'Keywords', :response_group => 'SimilarProducts', :sort => 'relevancerank', :item_page => '1', :search_index => 'Music'})
# @pull.tems.first.get('similarproduct[*]/asin(or title)')
