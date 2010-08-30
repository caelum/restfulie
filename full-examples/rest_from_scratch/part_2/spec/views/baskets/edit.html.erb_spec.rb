require 'spec_helper'

describe "baskets/edit.html.erb" do
  before(:each) do
    @basket = assign(:basket, stub_model(Basket,
      :new_record? => false
    ))
  end

  it "renders the edit basket form" do
    render

    rendered.should have_selector("form", :action => basket_path(@basket), :method => "post") do |form|
    end
  end
end
