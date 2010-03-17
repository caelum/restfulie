class Item < ActiveRecord::Base
  belongs_to :order

  def value 
    qt * price
  end

end
