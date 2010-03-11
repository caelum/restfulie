class RemovePaymentDate < ActiveRecord::Migration
  def self.up
    remove_column :payments, :payment_date
  end

  def self.down
  end
end
