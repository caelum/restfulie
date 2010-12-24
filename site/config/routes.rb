ActionController::Routing::Routes.draw do |map|
  
  map.root :controller => :systems, :action => :index
  map.benefits '/talking_about_restfulie', :controller => :systems, :action => :benefits
  map.support '/support', :controller => :systems, :action => :support
  map.rest '/what_is_rest_and_hateoas', :controller => :systems, :action => :rest
  map.java '/restful_java', :controller => :restful_java, :action => :installing
  map.rails '/restful_rails', :controller => :restful_rails, :action => :index
  map.csharp '/restful_csharp', :controller => :restful_csharp, :action => :installing
  map.features '/restfulie_features', :controller => :systems, :action => :restfulie_features
  
  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing or commenting them out if you're using named routes and resources.
  map.connect ':controller/:action'
  # map.connect ':controller/:action/:id.:format'
end
