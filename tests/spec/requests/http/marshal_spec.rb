require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

context Restfulie::Client::HTTP::RequestMarshaller do

  before(:all) do
    @marshaller = Restfulie::Client::HTTP::RequestMarshallerExecutor.new('http://localhost:4567')
  end

  context 'raw' do

    context 'shouldnt unmarshal if forcing raw' do
      
      let(:raw_response) { @marshaller.at('/songs').accepts('application/atom+xml').raw.get! }

      it "should respond to 200 code" do
        raw_response.code.should equal 200
      end
      
      it "response class should Restfulie response" do
        raw_response.class.should equal Restfulie::Client::HTTP::Response
      end
      
      it "body should equal to response data" do
        raw_response.body.should == response_data( 'atoms', 'songs' )
      end
      
    end
    
    context "follow 201 responses and shouldnt unmarshal if forcing raw" do
      let(:raw_response) { @marshaller.at('/test/redirect/songs').accepts('application/atom+xml').as("application/atom+xml").raw.post!('<?xml version="1.0" encoding="UTF-8" ?><feed xmlns="http://www.w3.org/2005/Atom"><id>http://example.com/albums/1</id><title>Albums feed</title><updated>2010-05-03T16:29:26-03:00</updated></feed>') }

      it "should respond to 200 code" do
        raw_response.response.code.should == 200        
      end

      it "body should equal to response data" do
        raw_response.response.body.should == response_data( 'atoms', 'songs' )        
      end

    end

  end

  context 'marshal' do

    before(:all) do
      Restfulie.recipe(:atom, :name => :custom_song) do |representation, song|
        representation.values do |value|
          value.id      "ID/#{song.id}"
          value.title   "Title #{song.title}"
          value.updated song.updated
        end        
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

      songs = @marshaller.at('/test/redirect/songs').as("application/atom+xml").post!(a_song)
      songs.response.code.should == 200

      songs = @marshaller.at('/test/redirect/songs').as("application/atom+xml").post!(a_song, :recipe => :custom_song)
      songs.response.code.should == 200
    end

  end
  
  it 'should understand a different response content type from its request' do
    result = Restfulie.at('http://localhost:4567/with_content').as("application/xml").post!('<order></order>')
    result.response.headers['content-type'].should == "application/atom+xml"
  end
end

context Restfulie::Client::HTTP::RequestMarshaller do
  it "should retrieve any content type if no accepts is specified" do
    result = Restfulie.at('http://localhost:4567/html_result').get!
    result.response.headers['content-type'].should == "text/html"
  end
end
