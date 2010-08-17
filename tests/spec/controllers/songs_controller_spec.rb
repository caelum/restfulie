require 'spec_helper'

describe SongsController do

  def mock_song(stubs={})
    @mock_song ||= mock_model(Song, stubs).as_null_object
  end

  describe "GET index" do
    it "assigns all songs as @songs" do
      Song.stub(:all) { [mock_song] }
      get :index
      assigns(:songs).should eq([mock_song])
    end
  end

  describe "GET show" do
    it "assigns the requested song as @song" do
      Song.stub(:find).with("37") { mock_song }
      get :show, :id => "37"
      assigns(:song).should be(mock_song)
    end
  end

  describe "GET new" do
    it "assigns a new song as @song" do
      Song.stub(:new) { mock_song }
      get :new
      assigns(:song).should be(mock_song)
    end
  end

  describe "GET edit" do
    it "assigns the requested song as @song" do
      Song.stub(:find).with("37") { mock_song }
      get :edit, :id => "37"
      assigns(:song).should be(mock_song)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created song as @song" do
        Song.stub(:new).with({'these' => 'params'}) { mock_song(:save => true) }
        post :create, :song => {'these' => 'params'}
        assigns(:song).should be(mock_song)
      end

      it "redirects to the created song" do
        Song.stub(:new) { mock_song(:save => true) }
        post :create, :song => {}
        response.should redirect_to(song_url(mock_song))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved song as @song" do
        Song.stub(:new).with({'these' => 'params'}) { mock_song(:save => false) }
        post :create, :song => {'these' => 'params'}
        assigns(:song).should be(mock_song)
      end

      it "re-renders the 'new' template" do
        Song.stub(:new) { mock_song(:save => false) }
        post :create, :song => {}
        response.should render_template("new")
      end
    end

  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested song" do
        Song.should_receive(:find).with("37") { mock_song }
        mock_song.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :song => {'these' => 'params'}
      end

      it "assigns the requested song as @song" do
        Song.stub(:find) { mock_song(:update_attributes => true) }
        put :update, :id => "1"
        assigns(:song).should be(mock_song)
      end

      it "redirects to the song" do
        Song.stub(:find) { mock_song(:update_attributes => true) }
        put :update, :id => "1"
        response.should redirect_to(song_url(mock_song))
      end
    end

    describe "with invalid params" do
      it "assigns the song as @song" do
        Song.stub(:find) { mock_song(:update_attributes => false) }
        put :update, :id => "1"
        assigns(:song).should be(mock_song)
      end

      it "re-renders the 'edit' template" do
        Song.stub(:find) { mock_song(:update_attributes => false) }
        put :update, :id => "1"
        response.should render_template("edit")
      end
    end

  end

  describe "DELETE destroy" do
    it "destroys the requested song" do
      Song.should_receive(:find).with("37") { mock_song }
      mock_song.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the songs list" do
      Song.stub(:find) { mock_song }
      delete :destroy, :id => "1"
      response.should redirect_to(songs_url)
    end
  end

end
