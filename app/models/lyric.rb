class Lyric < ActiveRecord::Base
  def self.search(search)
    if search
      find(:all, :conditions => ['title LIKE ?', "#{search}"])
    else
      find(:all)
    end
  end
  def self.searchall(searchall)
    if searchall
      find(:all, :conditions => ['artist LIKE ? OR album LIKE ? OR title LIKE ?', "#{searchall}%",  "#{searchall}%",  "#{searchall}%" ])  
    else
      find(:all)
    end
  end
   def self.artistsearch(artistsearch)
     if artistsearch
       find(:all, :conditions => ['artist LIKE ?', "#{artistsearch}%"])
     else
     
     end
   end
  def self.albumsearch(albumsearch)
    if albumsearch
      find(:all, :conditions => ['album LIKE ?', "#{albumsearch}%"])
    else
      find(:all)
    end
  end
  def self.titlesearch(titlesearch)
    if titlesearch
      find(:all, :conditions => ['title LIKE ?', "#{titlesearch}%"])
    else
      find(:all)
    end
  end
   
  def searchlyrics
    @searchlyrics ||= find_searchlyrics
  end

  private

  def find_searchlyrics
    searchlyric.find(:all, :conditions => conditions)
  end

  def keyword_conditions
    ["lyrics.name LIKE ?", "%#{keywords}%"] unless keywords.blank?
  end

  def category_conditions
    ["lyrics.artist = ?", ] unless artist.blank?
  end

  def conditions
    [conditions_clauses.join(' AND '), *conditions_options]
  end

  def conditions_clauses
    conditions_parts.map { |condition| condition.first }
  end

  def conditions_options
    conditions_parts.map { |condition| condition[1..-1] }.flatten
  end

  def conditions_parts
    private_methods(false).grep(/_conditions$/).map { |m| send(m) }.compact
  end
  
end
  
