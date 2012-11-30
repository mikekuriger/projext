ActionController::Routing::Routes.draw do |map|
  # Uncategorized for now
  map.resources :aliases
  map.resources :emails
  map.resources :domains
  map.resources :circuits
  
  map.connect 'documents/:id/:style.:format', :controller => 'documents', :action => 'download', :conditions => { :method => :get }
  map.resources :documents
  
  map.resources :ports

  map.resources :cpus
  map.resources :operatingsystems
  map.resources :hardware_models
  map.resources :manufacturers
  map.resources :sites
  map.resources :searches
  map.search '/search', :controller => 'searches', :action => 'index'
  map.resources :vendors
  
  map.connect 'diagrams/rack_elevation/:id.:format', :controller => 'diagrams', :action => 'rack_elevation', :conditions => { :method => :get }
  
  ###
  # Customer Portal
  map.resources :customers
  map.resources :contacts
  map.resources :apps
  map.resources :projects,
                :member => {
                  :activate => [ :get, :post ],
                  :deactivate => [ :get, :post ]
                }
  ###
  
  map.resources :crontabs

  ###
  # Finance
  map.resources :contracts
  map.connect 'contracts/download/:id.:format', :controller => 'contracts', :action => 'download', :conditions => { :method => :get }

  map.resources :quotes
  map.connect 'quotes/download/:id.:format', :controller => 'quotes', :action => 'download', :conditions => { :method => :get }
  
  map.resources :purchase_orders
  map.connect 'purchase_orders/download/:id.:format', :controller => 'purchase_orders', :action => 'download', :conditions => { :method => :get }
  ####
  
  ###
  # Assets
  map.resources :assets,
                :member => { :tooltip => [ :get ] },
                :has_many => [ :comments ]
  
  map.connect 'servers/autocomplete.:format', :controller => 'servers', :action => 'autocomplete', :conditions => { :method => :get }
  map.resources :servers,
                :has_many => [ :interfaces, :comments, :services ],
                :member => {
                  :tooltip => [ :get ],
                  :ping => [ :get, :post ],
                },
                :collection => {
                  :search => :get
                }

  map.resources :switches,
                :member => { :tooltip => [ :get ] },
                :has_many => [ :comments, :switch_modules ]
  map.resources :switch_modules,
                :member => { :tooltip => [ :get ] }
  map.resources :routers,
                :member => { :tooltip => [ :get ] }
  map.resources :networking_devices,
                :member => { :tooltip => [ :get ] }
  map.resources :load_balancers,
                :member => { :tooltip => [ :get ] }
  map.resources :firewalls,
                :member => { :tooltip => [ :get ] }
  
  map.resources :virtual_servers,
                :has_many => [ :interfaces, :comments, :services ],
                :member => {
                  :tooltip => [ :get ],
                  :ping => [ :get, :post ]
                }
                
  map.storage '/storage', :controller => 'storage_arrays', :action => 'index'
  map.resources :storage_arrays,
                :member => { :tooltip => [ :get ] }
  map.resources :storage_shelves,
                :member => { :tooltip => [ :get ] }
  map.resources :storage_heads,
                :member => { :tooltip => [ :get ] },
                :has_many => [ :interfaces ]
                
  map.resources :software_licenses
  ###

  ###
  # Asset location
  map.resources :equipment_racks
  map.connect 'racks/:id/diagram.:format', :controller => 'equipment_racks', :action => 'diagram'
  map.resources :racks, :controller => 'equipment_racks'
  map.resources :locations
  map.resources :rooms
  map.resources :buildings, :has_many => [ :rooms ]
  ###
  
  ###
  # Networking
  map.resources :media
  map.resources :cables
  map.resources :vips
  map.connect 'ips/autocomplete.:format', :controller => 'ips', :action => 'autocomplete', :conditions => { :method => :get }
  map.resources :ips
  map.resources :networks
  map.resources :interfaces
  ###
  
  ########
  ## Begin Classification
  map.resources :farms,
                :member => {
                  :activate => [ :get, :post ],
                  :deactivate => [ :get, :post ],
                  :diagram => :get
                }
                
  map.resources :services,
                :collection => {
                  :search => :get
                }

  map.connect 'clusters/autocomplete.:format', :controller => 'clusters', :action => 'autocomplete', :conditions => { :method => :get }
  map.resources :clusters,
                :member => {
                  :activate => [ :get, :post ],
                  :deactivate => [ :get, :post ]
                }
  
  map.connect 'functions/autocomplete.:format', :controller => 'functions', :action => 'autocomplete', :conditions => { :method => :get }
  map.resources :functions,
                :member => {
                  :activate => [ :get, :post ],
                  :deactivate => [ :get, :post ]
                }

  map.connect 'groups/autocomplete.:format', :controller => 'groups', :action => 'autocomplete', :conditions => { :method => :get }
  map.resources :groups,
                :member => {
                  :activate => [ :get, :post ],
                  :deactivate => [ :get, :post ]
                }

  map.resources :parameters,
    :member => {
      :activate => [ :get, :post ],
      :deactivate => [ :get, :post ]
    }

  map.resources :parameter_assignments

  ## End Classification
  ########
  
  ###
  # Miscellaneous
  map.resources :comments
  map.resource :dashboard
  map.resource :api_key
  ###

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  map.root :controller => 'home', :action => 'index'

  # See how all your routes lay out with "rake routes"


  # map.home '', :controller => 'home', :action => 'dashboard'
  map.with_options :controller => 'clearance/sessions'  do |m|
    m.login  '/login',  :action => 'new'
    m.logout '/logout', :action => 'destroy'
  end

  # map.namespace :admin do |admin|
  #   admin.resources :users
  # end

  # users/new route needs to be defined before other users routes so that local routes can override clearance's
  map.connect 'users/new', :controller => 'clearance/users', :action => 'new'  
  map.resources :users, :controller => 'users', :only => [:index, :show, :edit, :update, :destroy],
    :member => { :activate => [ :get, :post ], :disable => [ :get, :post ] }

  Clearance::Routes.draw(map)
  
  map.resources :agents,
                :has_one => :server,
                :member => {
                  :activate => [ :get, :post ],
                  :disable => [ :get, :post ]
                }
end

#== Route Map
# Generated on 06 Jan 2010 23:07
#
#              clusters GET    /clusters(.:format)                        {:controller=>"clusters", :action=>"index"}
#                       POST   /clusters(.:format)                        {:controller=>"clusters", :action=>"create"}
#           new_cluster GET    /clusters/new(.:format)                    {:controller=>"clusters", :action=>"new"}
#          edit_cluster GET    /clusters/:id/edit(.:format)               {:controller=>"clusters", :action=>"edit"}
#               cluster GET    /clusters/:id(.:format)                    {:controller=>"clusters", :action=>"show"}
#                       PUT    /clusters/:id(.:format)                    {:controller=>"clusters", :action=>"update"}
#                       DELETE /clusters/:id(.:format)                    {:controller=>"clusters", :action=>"destroy"}
#             functions GET    /functions(.:format)                       {:controller=>"functions", :action=>"index"}
#                       POST   /functions(.:format)                       {:controller=>"functions", :action=>"create"}
#          new_function GET    /functions/new(.:format)                   {:controller=>"functions", :action=>"new"}
#         edit_function GET    /functions/:id/edit(.:format)              {:controller=>"functions", :action=>"edit"}
#              function GET    /functions/:id(.:format)                   {:controller=>"functions", :action=>"show"}
#                       PUT    /functions/:id(.:format)                   {:controller=>"functions", :action=>"update"}
#                       DELETE /functions/:id(.:format)                   {:controller=>"functions", :action=>"destroy"}
#                groups GET    /groups(.:format)                          {:controller=>"groups", :action=>"index"}
#                       POST   /groups(.:format)                          {:controller=>"groups", :action=>"create"}
#             new_group GET    /groups/new(.:format)                      {:controller=>"groups", :action=>"new"}
#            edit_group GET    /groups/:id/edit(.:format)                 {:controller=>"groups", :action=>"edit"}
#                 group GET    /groups/:id(.:format)                      {:controller=>"groups", :action=>"show"}
#                       PUT    /groups/:id(.:format)                      {:controller=>"groups", :action=>"update"}
#                       DELETE /groups/:id(.:format)                      {:controller=>"groups", :action=>"destroy"}
#                assets GET    /assets(.:format)                          {:controller=>"assets", :action=>"index"}
#                       POST   /assets(.:format)                          {:controller=>"assets", :action=>"create"}
#             new_asset GET    /assets/new(.:format)                      {:controller=>"assets", :action=>"new"}
#            edit_asset GET    /assets/:id/edit(.:format)                 {:controller=>"assets", :action=>"edit"}
#                 asset GET    /assets/:id(.:format)                      {:controller=>"assets", :action=>"show"}
#                       PUT    /assets/:id(.:format)                      {:controller=>"assets", :action=>"update"}
#                       DELETE /assets/:id(.:format)                      {:controller=>"assets", :action=>"destroy"}
#                  root        /                                          {:controller=>"home", :action=>"index"}
#                 login        /login                                     {:controller=>"clearance/sessions", :action=>"new"}
#                logout        /logout                                    {:controller=>"clearance/sessions", :action=>"destroy"}
#             passwords POST   /passwords(.:format)                       {:controller=>"clearance/passwords", :action=>"create"}
#          new_password GET    /passwords/new(.:format)                   {:controller=>"clearance/passwords", :action=>"new"}
#           new_session GET    /session/new(.:format)                     {:controller=>"clearance/sessions", :action=>"new"}
#               session DELETE /session(.:format)                         {:controller=>"clearance/sessions", :action=>"destroy"}
#                       POST   /session(.:format)                         {:controller=>"clearance/sessions", :action=>"create"}
#    edit_user_password GET    /users/:user_id/password/edit(.:format)    {:controller=>"clearance/passwords", :action=>"edit"}
#         user_password PUT    /users/:user_id/password(.:format)         {:controller=>"clearance/passwords", :action=>"update"}
#                       POST   /users/:user_id/password(.:format)         {:controller=>"clearance/passwords", :action=>"create"}
# new_user_confirmation GET    /users/:user_id/confirmation/new(.:format) {:controller=>"clearance/confirmations", :action=>"new"}
#     user_confirmation POST   /users/:user_id/confirmation(.:format)     {:controller=>"clearance/confirmations", :action=>"create"}
#                 users GET    /users(.:format)                           {:controller=>"clearance/users", :action=>"index"}
#                       POST   /users(.:format)                           {:controller=>"clearance/users", :action=>"create"}
#              new_user GET    /users/new(.:format)                       {:controller=>"clearance/users", :action=>"new"}
#             edit_user GET    /users/:id/edit(.:format)                  {:controller=>"clearance/users", :action=>"edit"}
#                  user GET    /users/:id(.:format)                       {:controller=>"clearance/users", :action=>"show"}
#                       PUT    /users/:id(.:format)                       {:controller=>"clearance/users", :action=>"update"}
#                       DELETE /users/:id(.:format)                       {:controller=>"clearance/users", :action=>"destroy"}
#               sign_up        /sign_up                                   {:controller=>"clearance/users", :action=>"new"}
#               sign_in        /sign_in                                   {:controller=>"clearance/sessions", :action=>"new"}
#              sign_out        /sign_out                                  {:method=>:delete, :controller=>"clearance/sessions", :action=>"destroy"}
