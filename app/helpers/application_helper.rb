# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  require 'rubygems'
  require 'nokogiri'
  require 'open-uri'
  
  def artist_link(artist)
    link_to( artist.name, "../content/albums?album="+artist.id.to_s )
  end

  def find_top_artists
    @name = ["","","","",""]
    @artist_count = 0
    top_artists_url = "http://ws.audioscrobbler.com/2.0/?method=geo.gettopartists&country=USA&api_key=b25b959554ed76058ac220b7b2e0a026"
    @pull = Nokogiri::XML(open(top_artists_url))
    if @pull.xpath('//name') != nil
      @names = @pull.xpath('//name')
      @names.each do |name|
        if Artist.find(:all, :conditions =>{:name =>name}) != []
          @name[@artist_count] = name.text
          @artist_count += 1
        end
      end
    end
  end
  
end
