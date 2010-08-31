class ConnectBasketsToItems < ActiveRecord::Migration
  def self.up
    create_table :baskets_items, :id=> false, :force => true do |t|
      t.integer :basket_id
      t.integer :item_id
      t.timestamps
    end
  end

  def self.down
    drop_table :baskets_items
  end
end
