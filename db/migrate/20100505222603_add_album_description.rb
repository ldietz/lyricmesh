class AddAlbumDescription < ActiveRecord::Migration
  def self.up
    add_column :albums, :description, :text
  end

  def self.down
    remove_colum :albums, :description
  end
end
