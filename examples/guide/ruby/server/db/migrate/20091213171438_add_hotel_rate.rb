class AddHotelRate < ActiveRecord::Migration
  def self.up
    add_column :hotels, :rate, :integer
    Hotel.all.each do |h|
      h.rate = 3
      h.save
    end
  end

  def self.down
    remove_column :hotels, :rate
  end
end
