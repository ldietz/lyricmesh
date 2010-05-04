require 'amazon/ecs'

Amazon::Ecs.options = {:aWS_access_key_id => 'AKIAJAGMNKZHCOU7CBMQ',
  :aWS_secret_key => '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'}

query = 'Weezer Green'

@pull = Amazon::Ecs.item_search(query, {:type => 'Keywords', :response_group => 'Large', :sort => 'relevancerank', :item_page => '1', :search_index => 'Music'})

title = @pull.items.first.get('title')
price = @pull.items.first.get('formattedprice')
url = @pull.items.first.get('largeimage/url')
