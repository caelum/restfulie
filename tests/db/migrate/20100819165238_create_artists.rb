class CreateArtists < ActiveRecord::Migration
  def self.up
    create_table :artists do |t|
      t.string :name
      t.integer :album_id

      t.timestamps
    end
  end

  def self.down
    drop_table :artists
  end
end
