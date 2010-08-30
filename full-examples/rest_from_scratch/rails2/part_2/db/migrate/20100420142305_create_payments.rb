class CreatePayments < ActiveRecord::Migration
  def self.up
    create_table :payments do |t|
      t.string :cardnumber
      t.string :cardholder
      t.decimal :amount
      t.integer :basket_id

      t.timestamps
    end
  end

  def self.down
    drop_table :payments
  end
end
