require 'spec_helper'

describe "albums/edit.html.erb" do
  before(:each) do
    @album = assign(:album, stub_model(Album,
      :new_record? => false,
      :title => "MyString",
      :description => "MyString",
      :length => 1
    ))
  end

  it "renders the edit album form" do
    render

    rendered.should have_selector("form", :action => album_path(@album), :method => "post") do |form|
      form.should have_selector("input#album_title", :name => "album[title]")
      form.should have_selector("input#album_description", :name => "album[description]")
      form.should have_selector("input#album_length", :name => "album[length]")
    end
  end
end
