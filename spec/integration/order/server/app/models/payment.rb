class Payment < ActiveRecord::Base

  belongs_to :order
  after_create do |payment|
    payment.order.start_paying!
  end

  state_machine :initial => :waiting_for_approval do

    state :waiting_for_approval
    state :approved
    state :refused

    event :approve do
      transition :waiting_for_approval => :approved
    end

    event :refuse do
      transition :waiting_for_approval => :refused
    end

    before_transition :on => :approve do |payment,transition|
      payment.order.delivery!
    end

    before_transition :on => :refuse do |payment,transition|
      payment.order.cancel!
    end

  end

end
