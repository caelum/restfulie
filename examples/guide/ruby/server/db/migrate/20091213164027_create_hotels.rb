class CreateHotels < ActiveRecord::Migration
  def self.up
    create_table :hotels do |t|
      t.string :name
      t.string :city
      t.integer :room_count

      t.timestamps
    end
  end

  def self.down
    drop_table :hotels
  end
end
