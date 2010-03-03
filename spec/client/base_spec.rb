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
  end

  #it '' do
    #@songs.entries.size.should == 1
    #a_song = songs.entries.first
    #a_song.title.should == 'A Song'
    #a_song.id.should == ''
    #a_song.updated.should == ''
  #end

  #it 'should load songs and first song must have a relationship link to video' do
    #a_song = @songs.entries.first
    #a_song.video.get.title.should == 'A Song Video'
  #end

  #it '' do
    #a_song.video.post
    #a_song.video.put
    #a_song.video.delete
  #end

end

