class RenameAlbum < ActiveRecord::Migration
  def self.up
    rename_column :albums, :album, :title
  end

  def self.down
    rename_column :albums, :title, :album
  end
end
