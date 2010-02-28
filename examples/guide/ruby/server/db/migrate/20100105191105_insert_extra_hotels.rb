class InsertExtraHotels < ActiveRecord::Migration
  def self.up
    Hotel.new({:name => "Miami Objects", :city => "Miami", :room_count => 8, :rate => 4}).save
    Hotel.new({:name => "Resting in Miami", :city => "Miami", :room_count => 10, :rate => 3}).save
    Hotel.new({:name => "Restfulie in LA", :city => "Los Angeles", :room_count => 2, :rate => 5}).save
    Hotel.new({:name => "Los Angeles Objects", :city => "Los Angeles", :room_count => 16, :rate => 3}).save
  end

  def self.down
  end
end
