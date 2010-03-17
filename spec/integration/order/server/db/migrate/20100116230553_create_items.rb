class CreateItems < ActiveRecord::Migration
  def self.up
    create_table :items do |t|
      t.string  :name
      t.string  :kind
      t.integer :qt
      t.decimal :price
      t.timestamps
    end
  end

  def self.down
    drop_table :items
  end
end
