class Artist < ActiveRecord::Base
  has_many :albums
  has_many :songs, :through => :albums
  
  # cattr_reader :per_page
  # @@per_page = 1
  
  def self.search_name(search)
    find(:all, :conditions => ['name LIKE ?', "#{search}%"])
    # paginate :per_page => 17, :page => page,
    # :conditions => ['name like ?', "%#{search}%"],
    # :order => 'name'
  end

  def self.search_genre(search)
    find(:all, :conditions => ['genre LIKE ?', "#{search}%"])
  end
  
  define_index do
    indexes :name
  end
  
end
