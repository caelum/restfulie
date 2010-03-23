class CreateItems < ActiveRecord::Migration
  def self.up
    create_table :items do |t|
      t.string  :name
      t.string  :kind
      t.integer :qt, :default => 0
      t.decimal :price, :default => 0.0
      t.timestamps
    end
  end

  def self.down
    drop_table :items
  end
end
