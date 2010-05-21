module BillboardScrape
  require 'rubygems'
  require 'nokogiri'
  require 'open-uri'

  def billscrape
    top_100_url = "http://api.billboard.com/apisvc/chart/v1/list?id=379&api_key=w3a5as9mdhnnzu6s4nbj2kja"
    @pull = Nokogiri::XML(open(top_100_url))
    @top_100_artists = @pull.xpath('//chartItem/artist')
    @top_100_artists.each do |artist|
      @search_artists = Artist.find(:all, :conditions =>{:name =>artist.children.text.upcase})
      if @search_artists != [] and @search_artists.first != nil
      end
    @top_100_songs = @pull.xpath('//chartItem/song')
    end 
    puts @top_100
  end
end
