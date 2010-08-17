require 'spec_helper'

describe "albums/show.html.erb" do
  before(:each) do
    @album = assign(:album, stub_model(Album,
      :title => "Title",
      :description => "Description",
      :length => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    rendered.should contain("Title".to_s)
    rendered.should contain("Description".to_s)
    rendered.should contain(1.to_s)
  end
end
