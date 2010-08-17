require 'spec_helper'

describe "albums/new.html.erb" do
  before(:each) do
    assign(:album, stub_model(Album,
      :new_record? => true,
      :title => "MyString",
      :description => "MyString",
      :length => 1
    ))
  end

  it "renders new album form" do
    render

    rendered.should have_selector("form", :action => albums_path, :method => "post") do |form|
      form.should have_selector("input#album_title", :name => "album[title]")
      form.should have_selector("input#album_description", :name => "album[description]")
      form.should have_selector("input#album_length", :name => "album[length]")
    end
  end
end
