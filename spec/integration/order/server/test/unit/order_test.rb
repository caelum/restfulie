require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

class OrderTest < ActiveSupport::TestCase
  fixtures :items

  test 'an order should not transit to invalid state' do
    order = Order.create!
    assert order.opened?
    assert_raise StateMachine::InvalidTransition do
      order.delivery!
    end
  end

  test 'an order should be approved when has an item and payment is approved' do
    order = Order.create!
    assert order.opened?
    order << items(:towel)
    assert 0, order.amount 
    payment = order.pay
    assert payment.waiting_for_approval?
    assert order.paying?
    payment.approve!
    assert order.delivered?
    assert payment.approved?
  end

  test 'an order should be cancelled when has an item and payment is refused' do
    order = Order.create!
    assert order.opened?
    order << items(:towel)
    assert 0, order.amount 
    payment = order.pay
    assert payment.waiting_for_approval?
    assert order.paying?
    payment.refuse!
    assert order.cancelled?
    assert payment.refused?
  end

end
