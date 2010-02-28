class InsertBasicFlightRoutes < ActiveRecord::Migration
  def self.up
    Flight.new(:from => "Sao Paulo", :to => "Miami", :departure => Time.parse("08:55"), :arrival_after => (12.hours + 50.minutes)).save
    Flight.new(:from => "Sao Paulo", :to => "Miami", :departure => Time.parse("09:25"), :arrival_after => (11.hours + 50.minutes)).save
    Flight.new(:from => "Sao Paulo", :to => "Miami", :departure => Time.parse("13:45"), :arrival_after => (12.hours + 50.minutes)).save
    Flight.new(:from => "Sao Paulo", :to => "Miami", :departure => Time.parse("16:50"), :arrival_after => (13.hours + 50.minutes)).save
    Flight.new(:from => "Miami", :to => "Los Angeles", :departure => Time.parse("15:45"), :arrival_after => (8.hours + 15.minutes)).save
    Flight.new(:from => "Miami", :to => "Los Angeles", :departure => Time.parse("17:50"), :arrival_after => (7.hours + 50.minutes)).save
  end

  def self.down
    Flight.destroy_all
  end
end
