require File.join(File.dirname(__FILE__),'..','spec_helper')

module Restfulie::Client::Test
  class Song
    include ::Restfulie::Client::Base

    uses_restfulie do |config|
      config.entry_point     = 'http://localhost:4567/songs'
      config.default_headers = { 
        :get  => { 'Accept'       => 'application/atom+xml' },
        :post => { 'Content-Type' => 'application/atom+xml' } 
      }
      config.auto_follows = { 301 => [:post,:put,:delete] }
    end

  end
end

context Restfulie::Client::Base do

  before(:all) do
    @songs = Restfulie::Client::Test::Song.get!
  end

  it 'should load songs' do
    @songs.response.code.should == 200
    @songs.title.should == 'Songs feed'
    @songs.id.should == 'http://localhost:4567/songs'
    @songs.updated.year.should == 2010
    @songs.entries.size.should == 4
    a_song = @songs.entries.first
    a_song.title.should == 'Song 1'
    a_song.id.should == 'http://localhost:4567/songs_1'
  end

  it 'should load relationed top ten songs' do
    top_ten_songs = @songs.top_ten.get!
    top_ten_songs.response.code.should == 200
    top_ten_songs.title.should == 'Top Ten Songs feed'
    top_ten_songs.id.should == 'http://localhost:4567/songs_top_ten'
    top_ten_songs.updated.year.should == 2010
    a_song = top_ten_songs.entries.first
    a_song.title.should == 'Song 3'
    a_song.id.should == 'http://localhost:4567/song_3'
  end

  it 'should have in chained relationship' do
    top_ten_songs = @songs.top_ten.get!
    a_song = top_ten_songs.entries.first
    related_songs = a_song.related_songs.get!
    similar_song = related_songs.entries.first.similar_song
    similar_song.get!.title.should == 'Song 4 feed' 
  end

  #it '' do
    #a_song.video.post
    #a_song.video.put
    #a_song.video.delete
  #end

end

