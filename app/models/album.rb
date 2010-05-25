class Album < ActiveRecord::Base
  belongs_to :artist
  has_many :songs
  
  def self.search_title(search)
    find(:all, :conditions => ['artist_id LIKE ?', "#{search}%"], :include => [:artist])
  end

  define_index do
    indexes album
  end
  
end
