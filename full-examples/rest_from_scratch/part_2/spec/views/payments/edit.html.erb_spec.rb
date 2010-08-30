require 'spec_helper'

describe "payments/edit.html.erb" do
  before(:each) do
    @payment = assign(:payment, stub_model(Payment,
      :new_record? => false,
      :cardnumber => "MyString",
      :cardholder => "MyString",
      :amount => "9.99",
      :basket_id => 1
    ))
  end

  it "renders the edit payment form" do
    render

    rendered.should have_selector("form", :action => payment_path(@payment), :method => "post") do |form|
      form.should have_selector("input#payment_cardnumber", :name => "payment[cardnumber]")
      form.should have_selector("input#payment_cardholder", :name => "payment[cardholder]")
      form.should have_selector("input#payment_amount", :name => "payment[amount]")
      form.should have_selector("input#payment_basket_id", :name => "payment[basket_id]")
    end
  end
end
