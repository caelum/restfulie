require 'spec_helper'

describe "baskets/index.html.erb" do
  before(:each) do
    assign(:baskets, [
      stub_model(Basket),
      stub_model(Basket)
    ])
  end

  it "renders a list of baskets" do
    render
  end
end
