class Song < ActiveRecord::Base
  belongs_to :album
  belongs_to :artist

  def self.browse(search)
    find(:all, :conditions => ['album_id LIKE ?',"#{search}"])
  end

  define_index do
    indexes title
  end
  
end
