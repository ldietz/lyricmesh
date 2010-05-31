class Artist < ActiveRecord::Base
  has_many :albums
  has_many :songs, :through => :albums
  
  def self.search_name(search)
    find(:all, :conditions => ['name LIKE ?', "#{search}%"])
  end

  def self.search_genre(search)
    find(:all, :conditions => ['genre LIKE ?', "#{search}%"])
  end
  
  define_index do
    indexes :name
  end

  def self.search_top()
    @name = ["","","","",""]
    @artist_count = 0
    top_artists_url = "http://ws.audioscrobbler.com/2.0/?method=geo.gettopartists&country=USA&api_key=b25b959554ed76058ac220b7b2e0a026"
    @pull = Nokogiri::XML(open(top_artists_url))
    unless @pull.xpath('//name') == nil
      @names = @pull.xpath('//name')
      @names.each do |name|
        if Artist.find(:all, :conditions =>{:name =>name.text.upcase}) != []
          @name[@artist_count] = name.text.upcase
          @artist_count += 1
        end
      end
    end
    return @name
  end

end
