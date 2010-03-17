class CreatePayments < ActiveRecord::Migration
  def self.up
    create_table :payments do |t|
      t.double :amount
      t.string :cardholderName
      t.string :cardNumber
      t.int :expiryMonth
      t.int :expiryYear
      t.datetime :paymentDate

      t.timestamps
    end
  end

  def self.down
    drop_table :payments
  end
end
