class CreateFlights < ActiveRecord::Migration
  def self.up
    create_table :flights do |t|
      t.string :from
      t.string :to
      t.time :depature
      t.time :arrival

      t.timestamps
    end
  end

  def self.down
    drop_table :flights
  end
end
