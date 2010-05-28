class PaymentAndOrderRelation < ActiveRecord::Migration
  def self.up
    add_column :items, :order_id, :int, {:null => true, :default => 1}
    add_column :payments, :order_id, :int, {:null => true, :default => 1}
  end

  def self.down
    remove_column :payments, :order_id
    remove_column :items, :order_id
  end
end
