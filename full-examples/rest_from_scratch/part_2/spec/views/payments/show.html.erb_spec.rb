require 'spec_helper'

describe "payments/show.html.erb" do
  before(:each) do
    @payment = assign(:payment, stub_model(Payment,
      :cardnumber => "Cardnumber",
      :cardholder => "Cardholder",
      :amount => "9.99",
      :basket_id => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    rendered.should contain("Cardnumber".to_s)
    rendered.should contain("Cardholder".to_s)
    rendered.should contain("9.99".to_s)
    rendered.should contain(1.to_s)
  end
end
