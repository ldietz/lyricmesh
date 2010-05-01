class CreateAlbums < ActiveRecord::Migration
  def self.up
    create_table :albums do |t|
      t.string :album
      t.string :year
      t.string :photo_url
      t.references :artist
      t.timestamps
    end
  end

  def self.down
    drop_table :albums
  end
end
