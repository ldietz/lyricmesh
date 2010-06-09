class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.column  :id, :int
      t.column  :body, :text
      t.column  :song_id, :int
      t.timestamps
    end
  end

  def self.down
    drop_table :comments
  end
end
