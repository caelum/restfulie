class CreateItems < ActiveRecord::Migration
  def self.up
    create_table :items do |t|
      t.string :name
      t.decimal :price

      t.timestamps
    end
    Item.create :name => "Rest in practice", :price => 400.0
    Item.create :name => "Calpis", :price => 10.0
  end

  def self.down
    drop_table :items
  end
end
