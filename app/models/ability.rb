class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # in case of guest

    if (user.active?) then
      if (user.type == 'Agent') then    # For whamd agent
        # Allow server agents to create a new server only if they don't have one associated already
        if (user.server.nil?) then can :create, [ Server, VirtualServer ] end
        
        # Allow the server agent to update only its own server
        can [ :read, :update, :ping ], Server do |s|
          user.server.hostname == s.hostname unless (user.server.nil? || s.nil?)
        end
      else                          # For regular web users
        # Allow users to update their own profiles
        can [ :read, :update ], User do |u|
          u && u.email == user.email
        end
        
        if user.is? :guest
          can :read, [ Server, VirtualServer, StorageArray, StorageHead, StorageShelf, Group, Cluster, Function, Service, Room, Vendor,
                       Farm, Building, Site, Vip, Parameter, ParameterAssignment, GlobalParameter, Asset,
                       Switch, Router, Firewall, LoadBalancer, Search ]
        end
        
        if user.is? :executive then can :read, :all end
          
        if user.is? :syseng
          can :manage, [ Server, VirtualServer, StorageArray, StorageHead, StorageShelf, Group, Cluster, Function, Service, Room, Vendor,
                         Farm, Building, Site, Vip, Parameter, ParameterAssignment, GlobalParameter,
                         HardwareModel, Medium, Operatingsystem, Manufacturer, Rack, Room, Cpu ]
          can :read, [ Asset, Switch, Router, Firewall, LoadBalancer, Search ]
        end
        
        if user.is? :neteng
          can :manage, [ Switch, Cable, Room, Vendor, Router, Firewall, LoadBalancer, Medium ]
          can :read, [ Asset, Server, VirtualServer, StorageArray, StorageHead, StorageShelf, Group, Cluster, Function, Service, Site, Farm, Search ]
        end
        
        if user.is? :webeng
          can :manage, [ Asset, Server, VirtualServer, Site, Group, Cluster, Function, Service, Vendor, Vip, Parameter, ParameterAssignment, 
                         GlobalParameter ]
          can :read, [ Switch, Router, Firewall, LoadBalancer, StorageArray, StorageHead, StorageShelf, Farm, Search ]
        end
        
        if user.is? :finance
          can :read, [ Asset, Quote, PurchaseOrder, Vendor, Contract ]
        end
        
        if user.is? :puppet
          can :read, [ Server, VirtualServer, Service ]
        end
        
        if user.is? :nagios
          can :read, [ Server, VirtualServer ]
        end
        
        if user.is? :rt
          can :read, [ Customer, Project ]
        end
        
        if user.is? :admin
          can :manage, :all
          can :assign_roles, User
          can :assign_servers, User
          can :assign_agents, [ Server, VirtualServer ]
        end

        can [ :read ], Document do |doc|
          doc && can?(:read, doc.attachings.first.attachable_type)
        end
        
        can [ :update ], Document do |doc|
          doc && can?(:update, doc.attachings.first.attachable_type)
        end
      end
      
      # Set any default privileges here
      
    end
  end
end
