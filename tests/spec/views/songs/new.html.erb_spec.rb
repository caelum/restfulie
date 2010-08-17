require 'spec_helper'

describe "songs/new.html.erb" do
  before(:each) do
    assign(:song, stub_model(Song,
      :new_record? => true,
      :title => "MyString",
      :description => "MyString",
      :length => 1,
      :album_id => 1
    ))
  end

  it "renders new song form" do
    render

    rendered.should have_selector("form", :action => songs_path, :method => "post") do |form|
      form.should have_selector("input#song_title", :name => "song[title]")
      form.should have_selector("input#song_description", :name => "song[description]")
      form.should have_selector("input#song_length", :name => "song[length]")
      form.should have_selector("input#song_album_id", :name => "song[album_id]")
    end
  end
end
