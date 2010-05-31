# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def artist_link(artist)
    link_to( artist.name, "../content/albums?album="+artist.id.to_s )
  end  
end
