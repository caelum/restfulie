require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require File.join(File.dirname(__FILE__),'..', '..', 'lib','data_helper')

context Restfulie::Client::HTTP::RequestMarshaller do

  before(:all) do
    @marshaller = Restfulie::Client::HTTP::RequestMarshallerExecutor.new('http://localhost:4567')
  end

  context 'raw' do

    it 'shouldnt unmarshal if forcing raw' do
      raw_response = @marshaller.at('/songs').accepts('application/atom+xml').raw.get!
      raw_response.code.should == 200
      raw_response.class.should == Restfulie::Client::HTTP::Response
      raw_response.body.should == response_data( 'atoms', 'songs' )
    end 

    it 'should follow 201 responses and shouldnt unmarshal if forcing raw' do
      raw_response = @marshaller.at('/test/redirect/songs').accepts('application/atom+xml').raw.post!("custom")
      raw_response.code.should == 200
      raw_response.body.should == response_data( 'atoms', 'songs' )
    end

  end

  context 'marshal' do

    before(:all) do
      Restfulie.recipe(:atom, :name => :custom_song) do |representation, song|
        representation.id = "ID/#{song.id}"
        representation.title = "Title #{song.title}"
        representation.updated = song.updated
        representation
      end
    end

    it 'should unmarshal' do
      songs = @marshaller.at('/songs').accepts('application/atom+xml').get!

      songs.response.code.should == 200
      songs.title.should == 'Songs feed'
      songs.id.should == 'http://localhost:4567/songs'
      songs.updated.year.should == 2010
      songs.entries.size.should == 4

      a_song = songs.entries.first
      a_song.title.should == 'Song 1'
      a_song.id.should == 'http://localhost:4567/songs_1'

      top_ten_songs = songs.links.top_ten.get!
      top_ten_songs.response.code.should == 200
      top_ten_songs.title.should == 'Top Ten Songs feed'
      top_ten_songs.id.should == 'http://localhost:4567/songs_top_ten'
      top_ten_songs.updated.year.should == 2010
      a_song = top_ten_songs.entries.first
      a_song.title.should == 'Song 3'
      a_song.id.should == 'http://localhost:4567/song_3'

      top_ten_songs = songs.links.top_ten.get!
      a_song = top_ten_songs.entries.first
      related_songs = a_song.links.related_songs.get!
      similar_song = related_songs.entries.first.links.similar_song
      similar_song.get!.title.should == 'Song 4 feed' 
    end

    it 'should marshal' do
      songs = @marshaller.at('/songs').accepts('application/atom+xml').get!
      a_song = songs.entries.first
      a_song.title = "Update song #{a_song.title}"

      songs = @marshaller.at('/test/redirect/songs').post!(a_song)
      songs.response.code.should == 200

      songs = @marshaller.at('/test/redirect/songs').post!(a_song, :recipe => :custom_song)
      songs.response.code.should == 200
    end

  end

end
