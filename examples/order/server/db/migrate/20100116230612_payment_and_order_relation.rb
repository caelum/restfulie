class PaymentAndOrderRelation < ActiveRecord::Migration
  def self.up
    add_column :items, :order_id, :int
    add_column :payments, :order_id, :int

    rename_column :payments, :cardholderName, :cardholder_name
    rename_column :payments, :cardNumber, :card_number
    rename_column :payments, :paymentDate, :payment_date
    add_column :payments, :expiry_month, :integer
    add_column :payments, :expiry_year, :integer
    add_column :payments, :amount, :double
  end

  def self.down
    remove_column :payments, :amount
    remove_column :payments, :expiry_year
    remove_column :payments, :expiry_month
    rename_column :payments, :payment_date, :paymentDate
    rename_column :payments, :card_number, :cardNumber
    rename_column :payments, :cardholder_name, :cardholderName

    remove_column :payments, :order_id
    remove_column :items, :order_id
  end
end
