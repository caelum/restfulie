require 'spec_helper'

describe "songs/show.html.erb" do
  before(:each) do
    @song = assign(:song, stub_model(Song,
      :title => "Title",
      :description => "Description",
      :length => 1,
      :album_id => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    rendered.should contain("Title".to_s)
    rendered.should contain("Description".to_s)
    rendered.should contain(1.to_s)
    rendered.should contain(1.to_s)
  end
end
