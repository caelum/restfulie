ActionController::Routing::Routes.draw do |map|

  map.resources :orders, :only => [:create,:index] do |orders|
    orders.resources :items, :controller => 'orders/items', :only => [:create,:index,:show]
  end

  map.resources :items, :only => [:new,:destroy,:index,:create]

  map.resources :payments, :only => [:index]
  map.create_payment  '/payments/order/:id', :action => 'pay'    , :controller => 'payments', :conditions => { :method => :post }
  map.new_payment     '/payments/order/:id', :action => 'pay'    , :controller => 'payments', :conditions => { :method => :post }
  map.approve_payment '/payments/:id'      , :action => 'approve', :controller => 'payments', :conditions => { :method => :post }
  map.refuse_payment  '/payments/:id'      , :action => 'refuse' , :controller => 'payments', :conditions => { :method => :delete }

  #map.resources :order do |order|
    #order.post '/:id',:state => :opened, :action => :add_item
    #order.post '/'   ,:action => :create
    #order.get  '/'   ,:action => :index
  #end

  #map.resources :payment do |payment|
    #payment.post   '/:id'      ,:state => :waiting_for_approval, :action => :approve
    #payment.delete '/:id'      ,:state => :waiting_for_approval, :action => :refuse
    #payment.post   '/:order_id',:state => nil, :action => :pay
    #payment.post   '/:order_id',:action => :pay
  #end

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
  #map.connect ':controller/:action/:id'
  #map.connect ':controller/:action/:id.:format'
end
