class Song < ActiveRecord::Base
  belongs_to :album
  belongs_to :artist

  def self.browse(search)
    find(:all, :conditions => ['album_id LIKE ?',"#{search}"])
  end

  #def self.title(search)
  #  find(:all, :conditions => ['title LIKE ?', "#{search}%"])
  #end

  define_index do
    indexes title
    indexes lyrics
  end
  
end
