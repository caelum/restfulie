class Order < ActiveRecord::Base
  
  has_many :items
  has_one :payment

  state_machine :initial => :opened do

    state :opened
    state :paying
    state :cancelled
    state :delivered

    event :start_paying do
      transition :opened => :paying
    end

    event :delivery do
      transition :paying => :delivered
    end

    event :cancel do
      transition :paying => :cancelled
    end

  end

  def pay
    payment = Payment.create(:order => self)
  end

  def << (item)
    items << item
    self[:amount] = self[:amount] + item.value
  end

end

