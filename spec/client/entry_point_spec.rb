require File.join(File.dirname(__FILE__),'..','spec_helper')

context Restfulie::Client::EntryPoint do

  before(:all) do
    @songs = Restfulie::Client::EntryPoint.at('http://localhost:4567/songs').accepts('application/atom+xml').get!
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

