Breadcrumb.configure do
  # Specify name, link title and the URL to link to
  crumb :profile, "Your Profile", :account_url
  crumb :root, "Home", :root_url
  crumb :admin, "Admin", :root_url

  # Specify controller, action, and an array of the crumbs you specified above
#  trail :accounts, :show, [:root, :profile]
  context "assets" do
    crumb :assets, "Assets", :assets_path
    crumb :asset, '#{@asset.name}', :asset_path, :asset
    crumb :asset_new, "New", :new_asset_path
    crumb :asset_edit, "Edit", :edit_asset_path, :asset

    trail :assets, :index, [:root, :assets]
    trail :assets, :show, [:root, :assets, :asset]
    trail :assets, [:new, :create], [:root, :assets, :asset_new]
    trail :assets, [:edit, :update], [:root, :assets, :asset, :asset_edit]
  end
  
  context "servers" do
    crumb :servers, "Servers", :servers_path
    crumb :server, '#{@server.hostname}.#{@server.domain}', :server_path, :server
    crumb :server_new, "New", :new_server_path
    crumb :server_edit, "Edit", :edit_server_path, :server
    crumb :servers_search, "Search", :search_servers_path
    crumb :servers_search_query, '#{@query}', :current
    
    trail :servers, :index, [:root, :servers]
    trail :servers, :show, [:root, :servers, :server]
    trail :servers, [:new, :create], [:root, :servers, :server_new]
    trail :servers, [:edit, :update], [:root, :servers, :server, :server_edit]
    trail :servers, :search, [:root, :servers, :servers_search, :servers_search_query ]

    crumb :virtual_servers, "Virtual Servers", :servers_path
    crumb :virtual_server, '#{@virtual_server.hostname}.#{@virtual_server.domain}', :virtual_server_path, :virtual_server
    crumb :virtual_server_new, "New", :new_virtual_server_path
    crumb :virtual_server_edit, "Edit", :edit_virtual_server_path, :virtual_server
    
    trail :virtual_servers, :index, [:root, :virtual_servers]
    trail :virtual_servers, :show, [:root, :virtual_servers, :virtual_server]
    trail :virtual_servers, [:new, :create], [:root, :virtual_servers, :virtual_server_new]
    trail :virtual_servers, [:edit, :update], [:root, :virtual_servers, :virtual_server, :virtual_server_edit]
  end
  
  context "networking" do
    crumb :switches, "Switches", :switches_path
    crumb :switch, '#{@switch.hostname}.#{@switch.domain}', :switch_path, :switch
    crumb :switch_new, "New", :new_switch_path
    crumb :switch_edit, "Edit", :edit_switch_path, :switch

    crumb :firewalls, "Firewalls", :firewalls_path
    crumb :firewall, '#{@firewall.hostname}.#{@firewall.domain}', :firewall_path, :firewall
    crumb :firewall_new, "New", :new_firewall_path
    crumb :firewall_edit, "Edit", :edit_firewall_path, :firewall

    crumb :routers, "Routers", :routers_path
    crumb :router, '#{@router.hostname}.#{@router.domain}', :router_path, :router
    crumb :router_new, "New", :new_router_path
    crumb :router_edit, "Edit", :edit_router_path, :router

    crumb :load_balancers, "Load Balancers", :load_balancers_path
    crumb :load_balancer, '#{@load_balancer.hostname}.#{@load_balancer.domain}', :load_balancer_path, :load_balancer
    crumb :load_balancer_new, "New", :new_load_balancer_path
    crumb :load_balancer_edit, "Edit", :edit_load_balancer_path, :load_balancer
    
    crumb :networks, "Networks", :networks_path
    crumb :network, '#{@network.network}/#{@network.subnetbits}', :network_path, :network
    crumb :network_new, "New", :new_network_path
    crumb :network_edit, "Edit", :edit_network_path, :network
    
    trail :switches, :index, [:root, :switches]
    trail :switches, :show, [:root, :switches, :switch]
    trail :switches, [:new, :create], [:root, :switches, :switch_new]
    trail :switches, [:edit, :update], [:root, :switches, :switch, :switch_edit]

    trail :firewalls, :index, [:root, :firewalls]
    trail :firewalls, :show, [:root, :firewalls, :firewall]
    trail :firewalls, [:new, :create], [:root, :firewalls, :firewall_new]
    trail :firewalls, [:edit, :update], [:root, :firewalls, :firewall, :firewall_edit]

    trail :routers, :index, [:root, :routers]
    trail :routers, :show, [:root, :routers, :router]
    trail :routers, [:new, :create], [:root, :routers, :router_new]
    trail :routers, [:edit, :update], [:root, :routers, :router, :router_edit]

    trail :load_balancers, :index, [:root, :load_balancers]
    trail :load_balancers, :show, [:root, :load_balancers, :load_balancer]
    trail :load_balancers, [:new, :create], [:root, :load_balancers, :load_balancer_new]
    trail :load_balancers, [:edit, :update], [:root, :load_balancers, :load_balancer, :load_balancer_edit]

    trail :networks, :index, [:root, :networks]
    trail :networks, :show, [:root, :networks, :network]
    trail :networks, [:new, :create], [:root, :networks, :network_new]
    trail :networks, [:edit, :update], [:root, :networks, :network, :network_edit]
  end
  
  context "storage" do
    crumb :storage, "Storage", :storage_arrays_path
    
    crumb :storage_arrays, "Storage Arrays", :storage_arrays_path
    crumb :storage_array, '#{@storage_array.name}', :storage_array_path, :storage_array
    crumb :storage_array_new, "New", :new_storage_array_path
    crumb :storage_array_edit, "Edit", :edit_storage_array_path, :storage_array

    crumb :storage_heads, 'Storage Heads', :storage_head_path, :storage_head
    crumb :storage_head, '#{@storage_head.name}', :storage_head_path, :storage_head
    crumb :storage_head_new, "New", :new_storage_head_path
    crumb :storage_head_edit, "Edit", :edit_storage_head_path, :storage_head

    crumb :storage_shelves, 'Storage Shelves', :storage_shelf_path, :storage_shelf
    crumb :storage_shelf, '#{@storage_shelf.name}', :storage_shelf_path, :storage_shelf
    crumb :storage_shelf_new, "New", :new_storage_shelf_path
    crumb :storage_shelf_edit, "Edit", :edit_storage_shelf_path, :storage_shelf
    
    trail :storage, :index, [:root, :storage]
    
    trail :storage_arrays, :index, [:root, :storage_arrays]
    trail :storage_arrays, :show, [:root, :storage_arrays, :storage_array]
    trail :storage_arrays, [:new, :create], [:root, :storage_arrays, :storage_array_new]
    trail :storage_arrays, [:edit, :update], [:root, :storage_arrays, :storage_array, :storage_array_edit]

    trail :storage_heads, :index, [:root, :storage_heads]
    trail :storage_heads, :show, [:root, :storage_heads, :storage_head]
    trail :storage_heads, [:new, :create], [:root, :storage_heads, :storage_head_new]
    trail :storage_heads, [:edit, :update], [:root, :storage_heads, :storage_head, :storage_head_edit]

    trail :storage_shelves, :index, [:root, :storage_shelves]
    trail :storage_shelves, :show, [:root, :storage_shelves, :storage_shelf]
    trail :storage_shelves, [:new, :create], [:root, :storage_shelves, :storage_shelf_new]
    trail :storage_shelves, [:edit, :update], [:root, :storage_shelves, :storage_shelf, :storage_shelf_edit]
  end

  context "software" do
    crumb :software_licenses, "Software Licenses", :software_licenses_path
    crumb :software_license, '#{@software_license.name}', :software_license_path, :software_license
    crumb :software_license_new, "New", :new_software_license_path
    crumb :software_license_edit, "Edit", :edit_software_license_path, :software_license
    
    trail :software_licenses, :index, [:root, :software_licenses]
    trail :software_licenses, :show, [:root, :software_licenses, :software_license]
    trail :software_licenses, [:new, :create], [:root, :software_licenses, :software_license_new]
    trail :software_licenses, [:edit, :update], [:root, :software_licenses, :software_license, :software_license_edit]
  end

  context "groups" do
    crumb :groups, "Groups", :groups_path
    crumb :group, '#{@group.name}', :group_path, :group
    crumb :group_new, "New", :new_group_path
    crumb :group_edit, "Edit", :edit_group_path, :group
    
    trail :groups, :index, [:root, :groups]
    trail :groups, :show, [:root, :groups, :group]
    trail :groups, [:new, :create], [:root, :groups, :group_new]
    trail :groups, [:edit, :update], [:root, :groups, :group, :group_edit]
  end

  context "farms" do
    crumb :farms, "Farms", :farms_path
    crumb :farm, '#{@farm.name}', :farm_path, :farm
    crumb :farm_new, "New", :new_farm_path
    crumb :farm_edit, "Edit", :edit_farm_path, :farm
    crumb :farm_diagram, "Rack Diagram", :diagram_farm_path, :farm
    
    trail :farms, :index, [:root, :farms]
    trail :farms, :show, [:root, :farms, :farm]
    trail :farms, [:new, :create], [:root, :farms, :farm_new]
    trail :farms, [:edit, :update], [:root, :farms, :farm, :farm_edit]
    trail :farms, :diagram, [:root, :farms, :farm, :farm_diagram]
  end
  
  context "clusters" do
    crumb :clusters, "Clusters", :clusters_path
    crumb :cluster, '#{@cluster.name}', :cluster_path, :cluster
    crumb :cluster_new, "New", :new_cluster_path
    crumb :cluster_edit, "Edit", :edit_cluster_path, :cluster
    
    trail :clusters, :index, [:root, :clusters]
    trail :clusters, :show, [:root, :clusters, :cluster]
    trail :clusters, [:new, :create], [:root, :clusters, :cluster_new]
    trail :clusters, [:edit, :update], [:root, :clusters, :cluster, :cluster_edit]
  end
  
  context "functions" do
    crumb :functions, "Functions", :functions_path
    crumb :function, '#{@function.name}', :function_path, :function
    crumb :function_new, "New", :new_function_path
    crumb :function_edit, "Edit", :edit_function_path, :function
    
    trail :functions, :index, [:root, :functions]
    trail :functions, :show, [:root, :functions, :function]
    trail :functions, [:new, :create], [:root, :functions, :function_new]
    trail :functions, [:edit, :update], [:root, :functions, :function, :function_edit]
  end

  context "services" do
    crumb :services, "Services", :services_path
    crumb :service, '#{@service.cluster.name}::#{@service.function.name}', :service_path, :service
    crumb :service_new, "New", :new_service_path
    crumb :service_edit, "Edit", :edit_service_path, :service
    
    trail :services, :index, [:root, :services]
    trail :services, :show, [:root, :services, :service]
    trail :services, [:new, :create], [:root, :services, :service_new]
    trail :services, [:edit, :update], [:root, :services, :service, :service_edit]
  end
  
  context "racks" do
    crumb :racks, "Racks", :racks_path
    crumb :rack, '#{@rack.name}', :rack_path, :rack
    crumb :rack_new, "New", :new_rack_path
    crumb :rack_edit, "Edit", :edit_rack_path, :rack
    
    trail :racks, :index, [:root, :racks]
    trail :racks, :show, [:root, :racks, :rack]
    trail :racks, [:new, :create], [:root, :racks, :rack_new]
    trail :racks, [:edit, :update], [:root, :racks, :rack, :rack_edit]
  end
  
  context "users" do
    crumb :users, "Users", :users_path
    crumb :user, '#{@user.email}', :user_path, :user
    crumb :user_new, "New", :new_user_path
    crumb :user_edit, "Edit", :edit_user_path, :user
    
    trail :users, :index, [:admin, :users]
    trail :users, :show, [:admin, :users, :user]
    trail :users, [:new, :create], [:admin, :users, :user_new]
    trail :users, [:edit, :update], [:admin, :users, :user, :user_edit]
  end
  
  context "sites" do
    crumb :sites, "Sites", :sites_path
    crumb :site, '#{@site.name}', :site_path, :site
    crumb :site_new, "New", :new_site_path
    crumb :site_edit, "Edit", :edit_site_path, :site
    
    trail :sites, :index, [:root, :sites]
    trail :sites, :show, [:root, :sites, :site]
    trail :sites, [:new, :create], [:root, :sites, :site_new]
    trail :sites, [:edit, :update], [:root, :sites, :site, :site_edit]
  end
  
  context "vips" do
    crumb :vips, "VIPs", :vips_path
    crumb :vip, '#{@vip.name}', :vip_path, :vip
    crumb :vip_new, "New", :new_vip_path
    crumb :vip_edit, "Edit", :edit_vip_path, :vip
    
    trail :vips, :index, [:root, :vips]
    trail :vips, :show, [:root, :vips, :vip]
    trail :vips, [:new, :create], [:root, :vips, :vip_new]
    trail :vips, [:edit, :update], [:root, :vips, :vip, :vip_edit]
  end
  
  # Networking
  context "cables" do
    crumb :cables, "Cables", :cables_path
    crumb :cable, '#{@cable.interface.asset.name}<->#{@cable.interface_target.asset.name}', :cable_path, :cable
    crumb :cable_new, "New", :new_cable_path
    crumb :cable_edit, "Edit", :edit_cable_path, :cable
    
    trail :cables, :index, [:root, :cables]
    trail :cables, :show, [:root, :cables, :cable]
    trail :cables, [:new, :create], [:root, :cables, :cable_new]
    trail :cables, [:edit, :update], [:root, :cables, :cable, :cable_edit]
  end
  
  context "circuits" do
    crumb :circuits, "Circuits", :circuits_path
    crumb :circuit, '#{@circuit.name}', :circuit_path, :circuit
    crumb :circuit_new, "New", :new_circuit_path
    crumb :circuit_edit, "Edit", :edit_circuit_path, :circuit
    
    trail :circuits, :index, [:root, :circuits]
    trail :circuits, :show, [:root, :circuits, :circuit]
    trail :circuits, [:new, :create], [:root, :circuits, :circuit_new]
    trail :circuits, [:edit, :update], [:root, :circuits, :circuit, :circuit_edit]
  end
  
  # Customer Portal
  context "customers" do
    crumb :customers, "Customers", :customers_path
    crumb :customer, '#{@customer.name}', :customer_path, :customer
    crumb :customer_new, "New", :new_customer_path
    crumb :customer_edit, "Edit", :edit_customer_path, :customer
    
    trail :customers, :index, [:root, :customers]
    trail :customers, :show, [:root, :customers, :customer]
    trail :customers, [:new, :create], [:root, :customers, :customer_new]
    trail :customers, [:edit, :update], [:root, :customers, :customer, :customer_edit]
  end
  
  context "contacts" do
    crumb :contacts, "Contacts", :contacts_path
    crumb :contact, '#{@contact.name}', :contact_path, :contact
    crumb :contact_new, "New", :new_contact_path
    crumb :contact_edit, "Edit", :edit_contact_path, :contact
    
    trail :contacts, :index, [:root, :contacts]
    trail :contacts, :show, [:root, :contacts, :contact]
    trail :contacts, [:new, :create], [:root, :contacts, :contact_new]
    trail :contacts, [:edit, :update], [:root, :contacts, :contact, :contact_edit]
  end
  
  context "projects" do
    crumb :projects, "Projects", :projects_path
    crumb :project, '#{@project.name}', :project_path, :project
    crumb :project_new, "New", :new_project_path
    crumb :project_edit, "Edit", :edit_project_path, :project
    
    trail :projects, :index, [:root, :projects]
    trail :projects, :show, [:root, :projects, :project]
    trail :projects, [:new, :create], [:root, :projects, :project_new]
    trail :projects, [:edit, :update], [:root, :projects, :project, :project_edit]
  end
  
  context "apps" do
    crumb :apps, "Applications", :apps_path
    crumb :app, '#{@app.name}', :app_path, :app
    crumb :app_new, "New", :new_app_path
    crumb :app_edit, "Edit", :edit_app_path, :app
    
    trail :apps, :index, [:root, :apps]
    trail :apps, :show, [:root, :apps, :app]
    trail :apps, [:new, :create], [:root, :apps, :app_new]
    trail :apps, [:edit, :update], [:root, :apps, :app, :app_edit]
  end
  
  # Finance
  context "contracts" do
    crumb :contracts, "Contracts", :contracts_path
    crumb :contract, '#{@contract.name}', :contract_path, :contract
    crumb :contract_new, "New", :new_contract_path
    crumb :contract_edit, "Edit", :edit_contract_path, :contract
    
    trail :contracts, :index, [:root, :contracts]
    trail :contracts, :show, [:root, :contracts, :contract]
    trail :contracts, [:new, :create], [:root, :contracts, :contract_new]
    trail :contracts, [:edit, :update], [:root, :contracts, :contract, :contract_edit]
  end
  
  context "quotes" do
    crumb :quotes, "Quotes", :quotes_path
    crumb :quote, '#{@quote.name}', :quote_path, :quote
    crumb :quote_new, "New", :new_quote_path
    crumb :quote_edit, "Edit", :edit_quote_path, :quote
    
    trail :quotes, :index, [:root, :quotes]
    trail :quotes, :show, [:root, :quotes, :quote]
    trail :quotes, [:new, :create], [:root, :quotes, :quote_new]
    trail :quotes, [:edit, :update], [:root, :quotes, :quote, :quote_edit]
  end

  context "purchase_orders" do
    crumb :purchase_orders, "Purchase Orders", :purchase_orders_path
    crumb :purchase_order, '#{@purchase_order.name}', :purchase_order_path, :purchase_order
    crumb :purchase_order_new, "New", :new_purchase_order_path
    crumb :purchase_order_edit, "Edit", :edit_purchase_order_path, :purchase_order
    
    trail :purchase_orders, :index, [:root, :purchase_orders]
    trail :purchase_orders, :show, [:root, :purchase_orders, :purchase_order]
    trail :purchase_orders, [:new, :create], [:root, :purchase_orders, :purchase_order_new]
    trail :purchase_orders, [:edit, :update], [:root, :purchase_orders, :purchase_order, :purchase_order_edit]
  end
  
  trail :home, :index, [:root]

  # Specify the delimiter for the crumbs
  delimit_with "&raquo;"
end
