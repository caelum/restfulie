require 'spec_helper'

describe BasketsController do

  def mock_basket(stubs={})
    @mock_basket ||= mock_model(Basket, stubs).as_null_object
  end

  describe "GET index" do
    it "assigns all baskets as @baskets" do
      Basket.stub(:all) { [mock_basket] }
      get :index
      assigns(:baskets).should eq([mock_basket])
    end
  end

  describe "GET show" do
    it "assigns the requested basket as @basket" do
      Basket.stub(:find).with("37") { mock_basket }
      get :show, :id => "37"
      assigns(:basket).should be(mock_basket)
    end
  end

  describe "GET new" do
    it "assigns a new basket as @basket" do
      Basket.stub(:new) { mock_basket }
      get :new
      assigns(:basket).should be(mock_basket)
    end
  end

  describe "GET edit" do
    it "assigns the requested basket as @basket" do
      Basket.stub(:find).with("37") { mock_basket }
      get :edit, :id => "37"
      assigns(:basket).should be(mock_basket)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created basket as @basket" do
        Basket.stub(:new).with({'these' => 'params'}) { mock_basket(:save => true) }
        post :create, :basket => {'these' => 'params'}
        assigns(:basket).should be(mock_basket)
      end

      it "redirects to the created basket" do
        Basket.stub(:new) { mock_basket(:save => true) }
        post :create, :basket => {}
        response.should redirect_to(basket_url(mock_basket))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved basket as @basket" do
        Basket.stub(:new).with({'these' => 'params'}) { mock_basket(:save => false) }
        post :create, :basket => {'these' => 'params'}
        assigns(:basket).should be(mock_basket)
      end

      it "re-renders the 'new' template" do
        Basket.stub(:new) { mock_basket(:save => false) }
        post :create, :basket => {}
        response.should render_template("new")
      end
    end

  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested basket" do
        Basket.should_receive(:find).with("37") { mock_basket }
        mock_basket.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :basket => {'these' => 'params'}
      end

      it "assigns the requested basket as @basket" do
        Basket.stub(:find) { mock_basket(:update_attributes => true) }
        put :update, :id => "1"
        assigns(:basket).should be(mock_basket)
      end

      it "redirects to the basket" do
        Basket.stub(:find) { mock_basket(:update_attributes => true) }
        put :update, :id => "1"
        response.should redirect_to(basket_url(mock_basket))
      end
    end

    describe "with invalid params" do
      it "assigns the basket as @basket" do
        Basket.stub(:find) { mock_basket(:update_attributes => false) }
        put :update, :id => "1"
        assigns(:basket).should be(mock_basket)
      end

      it "re-renders the 'edit' template" do
        Basket.stub(:find) { mock_basket(:update_attributes => false) }
        put :update, :id => "1"
        response.should render_template("edit")
      end
    end

  end

  describe "DELETE destroy" do
    it "destroys the requested basket" do
      Basket.should_receive(:find).with("37") { mock_basket }
      mock_basket.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the baskets list" do
      Basket.stub(:find) { mock_basket }
      delete :destroy, :id => "1"
      response.should redirect_to(baskets_url)
    end
  end

end
