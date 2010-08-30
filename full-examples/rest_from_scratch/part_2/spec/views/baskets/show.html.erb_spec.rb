require 'spec_helper'

describe "baskets/show.html.erb" do
  before(:each) do
    @basket = assign(:basket, stub_model(Basket))
  end

  it "renders attributes in <p>" do
    render
  end
end
