class Basket < ActiveRecord::Base
  
  has_and_belongs_to_many :items
  has_many :payments
  
  def price
    items.inject(0) do |total, item|
      total + item.price
    end
  end
  
end
