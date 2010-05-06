class AddDescriptionGenreArtist < ActiveRecord::Migration
  def self.up
    add_column :artists, :description, :text
    add_column :artists, :genre, :string
  end

  def self.down
    remove_column :artists, :description
    remove_column :artists, :genre
  end
end
