class CreateOrders < ActiveRecord::Migration
  def self.up
    create_table :orders do |t|
      t.string :state
      t.decimal :amount, :default => 0.0
      t.boolean :payed
      t.timestamps
    end
  end

  def self.down
    drop_table :orders
  end
end
