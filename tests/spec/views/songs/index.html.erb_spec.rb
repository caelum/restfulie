require 'spec_helper'

describe "songs/index.html.erb" do
  before(:each) do
    assign(:songs, [
      stub_model(Song,
        :title => "Title",
        :description => "Description",
        :length => 1,
        :album_id => 1
      ),
      stub_model(Song,
        :title => "Title",
        :description => "Description",
        :length => 1,
        :album_id => 1
      )
    ])
  end

  it "renders a list of songs" do
    render
    rendered.should have_selector("tr>td", :content => "Title".to_s, :count => 2)
    rendered.should have_selector("tr>td", :content => "Description".to_s, :count => 2)
    rendered.should have_selector("tr>td", :content => 1.to_s, :count => 2)
    rendered.should have_selector("tr>td", :content => 1.to_s, :count => 2)
  end
end
