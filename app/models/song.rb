class Song < ActiveRecord::Base
  belongs_to :album
  belongs_to :artist
  has_many :comments
  
  def self.browse(search)
    find(:all, :conditions => ['album_id LIKE ?',"#{search}"])
  end

  define_index do
    indexes title
  end
  
end
