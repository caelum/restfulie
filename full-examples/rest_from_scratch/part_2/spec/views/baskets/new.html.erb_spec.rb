require 'spec_helper'

describe "baskets/new.html.erb" do
  before(:each) do
    assign(:basket, stub_model(Basket,
      :new_record? => true
    ))
  end

  it "renders new basket form" do
    render

    rendered.should have_selector("form", :action => baskets_path, :method => "post") do |form|
    end
  end
end
