require 'spec_helper'

describe "payments/new.html.erb" do
  before(:each) do
    assign(:payment, stub_model(Payment,
      :new_record? => true,
      :cardnumber => "MyString",
      :cardholder => "MyString",
      :amount => "9.99",
      :basket_id => 1
    ))
  end

  it "renders new payment form" do
    render

    rendered.should have_selector("form", :action => payments_path, :method => "post") do |form|
      form.should have_selector("input#payment_cardnumber", :name => "payment[cardnumber]")
      form.should have_selector("input#payment_cardholder", :name => "payment[cardholder]")
      form.should have_selector("input#payment_amount", :name => "payment[amount]")
      form.should have_selector("input#payment_basket_id", :name => "payment[basket_id]")
    end
  end
end
