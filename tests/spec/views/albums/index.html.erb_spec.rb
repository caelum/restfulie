require 'spec_helper'

describe "albums/index.html.erb" do
  before(:each) do
    assign(:albums, [
      stub_model(Album,
        :title => "Title",
        :description => "Description",
        :length => 1
      ),
      stub_model(Album,
        :title => "Title",
        :description => "Description",
        :length => 1
      )
    ])
  end

  it "renders a list of albums" do
    render
    rendered.should have_selector("tr>td", :content => "Title".to_s, :count => 2)
    rendered.should have_selector("tr>td", :content => "Description".to_s, :count => 2)
    rendered.should have_selector("tr>td", :content => 1.to_s, :count => 2)
  end
end
