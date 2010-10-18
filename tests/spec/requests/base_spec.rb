require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

context Restfulie::Client::Base do

  before(:all) do
    # module Restfulie::Client::Test
    #   class Song
    #     include ::Restfulie::Client::Base
    #     uses_restfulie { |config| config.entry_point = 'http://localhost:4567/songs' }
    #   end
    # end
    # @songs_from_class = Restfulie::Client::Test::Song.accepts("application/atom+xml").get!
  end

  it 'should load songs' do
    @songs_from_class.response.code.should == 200
    @songs_from_class.title.should == 'Songs feed'
    @songs_from_class.id.should == 'http://localhost:4567/songs'
    @songs_from_class.updated.year.should == 2010
    @songs_from_class.entries.size.should == 4
    a_song = @songs_from_class.entries.first
    a_song.title.should == 'Song 1'
    a_song.id.should == 'http://localhost:4567/songs_1'
  end


  it 'should load top ten songs' do
    top_ten_songs = @songs_from_class.links.top_ten.get!
    top_ten_songs.response.code.should == 200
    top_ten_songs.title.should == 'Top Ten Songs feed'
    top_ten_songs.id.should == 'http://localhost:4567/songs_top_ten'
    top_ten_songs.updated.year.should == 2010
    a_song = top_ten_songs.entries.first
    a_song.title.should == 'Song 3'
    a_song.id.should == 'http://localhost:4567/song_3'
  end

  it 'should load chained relationship' do
    top_ten_songs = @songs_from_class.links.top_ten.get!
    a_song = top_ten_songs.entries.first
    related_songs = a_song.links.related_songs.get!
    first_related_song = related_songs.entries.first
    similar_song = first_related_song.links.similar_song
    similar_song.get!.title.should == 'Song 4 feed' 
  end

  #it '' do
    #a_song.video.post
    #a_song.video.put
    #a_song.video.delete
  #end

end

context Restfulie::Client::EntryPoint do

  before(:all) do
    b = Restfulie::Client::EntryPoint.at('http://localhost:4567/songs').accepts('application/atom+xml')
    puts b
    @songs_from_ep = Restfulie::Client::EntryPoint.at('http://localhost:4567/songs').accepts('application/atom+xml').get!
  end

  it 'should load songs' do
    @songs_from_ep.response.code.should == 200
    @songs_from_ep.title.should == 'Songs feed'
    @songs_from_ep.id.should == 'http://localhost:4567/songs'
    @songs_from_ep.updated.year.should == 2010
    @songs_from_ep.entries.size.should == 4
    a_song = @songs_from_ep.entries.first
    a_song.title.should == 'Song 1'
    a_song.id.should == 'http://localhost:4567/songs_1'
  end

  it 'should load top ten songs' do
    top_ten_songs = @songs_from_ep.links.top_ten.get!
    top_ten_songs.response.code.should == 200
    top_ten_songs.title.should == 'Top Ten Songs feed'
    top_ten_songs.id.should == 'http://localhost:4567/songs_top_ten'
    top_ten_songs.updated.year.should == 2010
    a_song = top_ten_songs.entries.first
    a_song.title.should == 'Song 3'
    a_song.id.should == 'http://localhost:4567/song_3'
  end

  it 'should load chained relationship' do
    top_ten_songs = @songs_from_ep.links.top_ten.get!
    a_song = top_ten_songs.entries.first
    related_songs = a_song.links.related_songs.get!
    similar_song = related_songs.entries.first.links.similar_song
    similar_song.get!.title.should == 'Song 4 feed' 
  end

  #it '' do
    #a_song.video.post
    #a_song.video.put
    #a_song.video.delete
  #end

end

context Restfulie do

  context 'Delegate to entrypoint' do

    before(:all) do
      @songs = Restfulie.at('http://localhost:4567/songs').accepts('application/atom+xml').get!
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

    it 'should load top ten songs' do
      top_ten_songs = @songs.links.top_ten.get!
      top_ten_songs.response.code.should == 200
      top_ten_songs.title.should == 'Top Ten Songs feed'
      top_ten_songs.id.should == 'http://localhost:4567/songs_top_ten'
      top_ten_songs.updated.year.should == 2010
      a_song = top_ten_songs.entries.first
      a_song.title.should == 'Song 3'
      a_song.id.should == 'http://localhost:4567/song_3'
    end

    it 'should load chained relationship' do
      top_ten_songs = @songs.links.top_ten.get!
      a_song = top_ten_songs.entries.first
      related_songs = a_song.links.related_songs.get!
      similar_song = related_songs.entries.first.links.similar_song
      similar_song.get!.title.should == 'Song 4 feed' 
    end
  end

end
