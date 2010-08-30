require 'spec_helper'

describe "payments/index.html.erb" do
  before(:each) do
    assign(:payments, [
      stub_model(Payment,
        :cardnumber => "Cardnumber",
        :cardholder => "Cardholder",
        :amount => "9.99",
        :basket_id => 1
      ),
      stub_model(Payment,
        :cardnumber => "Cardnumber",
        :cardholder => "Cardholder",
        :amount => "9.99",
        :basket_id => 1
      )
    ])
  end

  it "renders a list of payments" do
    render
    rendered.should have_selector("tr>td", :content => "Cardnumber".to_s, :count => 2)
    rendered.should have_selector("tr>td", :content => "Cardholder".to_s, :count => 2)
    rendered.should have_selector("tr>td", :content => "9.99".to_s, :count => 2)
    rendered.should have_selector("tr>td", :content => 1.to_s, :count => 2)
  end
end
