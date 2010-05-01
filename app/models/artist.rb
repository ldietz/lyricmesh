class Artist < ActiveRecord::Base
  has_many :albums
  has_many :songs, :through => :albums

  def self.search_name(search)
    find(:all, :conditions => ['name LIKE ?', "#{search}%"])
  end

  define_index do
    indexes :name
  end
  
end
