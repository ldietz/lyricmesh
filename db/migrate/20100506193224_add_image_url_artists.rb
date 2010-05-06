class AddImageUrlArtists < ActiveRecord::Migration
  def self.up
    add_column :artists, :image_url, :string
  end

  def self.down
    remove_column :artists, :image_url
  end
end
