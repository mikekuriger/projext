class Asset < ActiveRecord::Base
  attr_accessible :name, :description, :serial, :wb_asset_id, :hardware, :hardware_id, :uuid, :vm_power_state, :oob,
                  :group, :group_id, :group_name, :farm, :farm_id,
                  :equipment_rack, :equipment_rack_id, :rack_elevation, :rack_units, :purchase_date, :vendor_id, :leased,
                  :sap_asset_id, :sap_wbs_element, :monitorable, :state, :room_id, :building_id,
                  :hardware_model_name, :hardware_model_id, :asset_id,
                  :cpu_count, :physical_memory, :cpu_type, :cpu_speed, :cpu_id,
                  :manufacturer_id, :room, :service_ids, :kernel, :kernel_release, :notes,
                  :type_helper
  
  
  ACTIVE_STATES = [ :new, :whamd_registered, :received, :installed, :in_service ]
  INACTIVE_STATES = [ :out_of_service, :decommissioned, :disposed ]
  
  #########
  # Getter and setter methods for type_helper virtual attribute
  def type_helper   
    self.type 
  end 
  def type_helper=(type)   
    self.type = type
  end
  #########
  
  #########
  # Getter and setter methods for autocomplete association (http://railscasts.com/episodes/102-auto-complete-association)
  def group_name
    group.name if group
  end
  def group_description
    group.description if group
  end
  def group_name=(name)
    self.group = Group.find_or_create_by_name(name) unless name.blank?
  end
  #########
  
  #########
  attr_accessor :cpu_type, :cpu_speed
  before_save :find_or_create_cpu
  def find_or_create_cpu
    self.cpu = Cpu.find_or_create_by_cpu_type_and_speed(@cpu_type, @cpu_speed) unless @cpu_type.blank?
  end
  
  def hardware_model_name
    hardware_model.name if hardware_model
  end
  def hardware_model_name=(name)
    self.hardware_model = HardwareModel.find_or_create_by_name(name) unless name.blank?
  end
  ##########
  
  ##
  # Accessors for manufacturer and manufacturer_id (used for cascading selects in server form)       
  attr_accessor :manufacturer_id
  def manufacturer
    hardware_model.manufacturer if hardware_model
  end
  def manufacturer_id
    hardware_model.manufacturer.id if hardware_model
  end
  
  # Accessors for building and room
  attr_accessor :building_id
  def building
    equipment_rack.room.building if equipment_rack
  end
  def building_id
    equipment_rack.room.building.id if equipment_rack
  end
  
  attr_accessor :room_id
  def room
    equipment_rack.room if equipment_rack
  end
  def room_id
    equipment_rack.room.id if equipment_rack
  end
  ##
  
  # By default, we want records ordered by name, ascending
  default_scope :order => 'assets.name ASC'
  
  # So that Asset.active, Asset.inactive, etc. will work
  named_scope :active, :conditions => ACTIVE_STATES.map{|state| "state = '#{state}'"}.join(" OR ")
  named_scope :inactive, :conditions => INACTIVE_STATES.map{|state| "state = '#{state}'"}.join(" OR ")
  
  
  belongs_to :group
  belongs_to :farm
  
  belongs_to :hardware_model
  
  belongs_to :equipment_rack
  
  has_many :service_assignments, :dependent => :restrict
  has_many :services, :through => :service_assignments
  has_many :functions, :through => :services
  has_many :clusters, :through => :services
  has_many :sites, :through => :clusters
  has_many :ips, :through => :sites   # Maybe this should be through interfaces instead?
  
  has_many :interfaces, :dependent => :destroy
  has_many :cables, :through => :interfaces

  has_many :crontabs_assets, :dependent => :restrict
  has_many :crontabs, :through => :crontabs_assets
  
  has_many :vips_assets
  has_many :vips, :through => :vips_assets
  
  belongs_to :operatingsystem
  
  belongs_to :vendor
  
  belongs_to :cpu
  
  has_many :parameter_assignments, :as => :assignable
  has_many :parameters, :through => :parameter_assignments
  
  validates_presence_of :name, :message => "Asset name can't be blank"
  #validates_uniqueness_of :name, :message => "Asset name must be unique"
  # validates_presence_of :serial, :message => "Asset serial can't be blank"
  # validates_uniqueness_of :serial, :message => "Asset serial must be unique"
  
  has_many :assets_contracts
  has_many :contracts, :through => :assets_contracts do
    def current
      find(:all, :conditions => ['contracts.start <= ? AND contracts.end >= ?', Time.now, Time.now])
    end
  end
  has_many :purchaseorders, :through => :contracts
  has_many :quotes, :through => :contracts
  
  #########
  ## Nested models (Asset has many interfaces)
  ## See http://railscasts.com/episodes/196-nested-model-form-part-1 and http://railscasts.com/episodes/197-nested-model-form-part-2

  attr_accessible :interfaces_attributes
  accepts_nested_attributes_for :interfaces,
                                :reject_if => lambda { |a| a[:name].blank? },
                                :allow_destroy => true
  #########
  
  # Possible asset types (used in type form fields)
  # [display_name, class_name]
  TYPE_OPTIONS = [
      ['Asset', 'Asset'], 
      ['Server', 'Server'], 
      ['Virtual Server', 'VirtualServer'], 
      ['Switch', 'Switch'], 
      ['Router', 'Router'], 
      ['Load Balancer', 'LoadBalancer'], 
      ['Firewall', 'Firewall'], 
      ['Storage Array', 'StorageArray'],
      ['Storage Controller', 'StorageHead'], 
      ['Storage Shelf', 'StorageShelf'],
      ['Tape Drive', 'Tape Drive']
    ]
  
  # From friendly_id plugin (http://github.com/norman/friendly_id)
  # has_friendly_id :name, :use_slug => true
  
  # Enable versioning
  has_paper_trail :ignore => [:last_seen], :meta => { :asset_id => Proc.new { |a| a.id }}    # the meta block sets the custom asset_id field
  
  # Enable commenting
  acts_as_commentable
  
  # Enable tagging
  acts_as_taggable_on :tags
  
  # Search indexing via Thinking Sphinx
  define_index do
    indexes :name, :sortable => true
    indexes [hostname, domain], :as => :fqdn
    indexes serial
    indexes group(:name), :as => :group_name, :sortable => true
    indexes farm(:name), :as => :farm_name, :sortable => true
    indexes interfaces.mac, :as => :mac
    indexes hardware_model(:name), :as => :hardware_model_name, :sortable => true
    indexes operatingsystem(:name), :as => :operating_system_name, :sortable => true
    indexes type
    indexes state
  
    has group_id, farm_id, created_at, updated_at
    
    #set_property :min_prefix_len => 3   # Minimum number of characters to index as a prefix
    #set_property :prefix_fields => 'name, hostname'  # Only do prefix indexing for specific fields
    
    set_property :min_infix_len => 2    # Minimum number of characters to index as an infix
    set_property :infix_fields => 'name, fqdn, serial, group_name, farm_name'   # Only do infix indexing for specific fields
    set_property :delta => true
  end
   
  # State Machine
  # Assets can have any of the following states:
  # * new
  # When an asset is first added to WHAM, it receives this state by default before transitioning into the other states.
  #
  # * whamd_registered
  # Special state: When an asset is automatically added to WHAM by whamd, it is automatically transitioned to this state. Once an admin approves, it will transition to either the installed or in_service states.
  #
  # * received
  # When a new asset is received and tested, etc., it enters this state.
  # 
  # * installed
  # For a server/network/storage asset to be marked as installed, it must have all cabling and location information specified, as well as other key data.
  # 
  # * in_service (AKA active)
  # When an asset goes live, it enters the inservice state.
  # 
  # * out_of_service
  # When an asset has reached the end of its life and is ready to be decommissioned, it enters the out_of_service state.
  # 
  # * decommissioned
  # When an asset is removed from its rack or in-use location, it enters the decommissioned state.
  # 
  # * disposed
  # After disposal, an asset enters the disposed state.
  
  state_machine :initial => :new do
    event :receive do
      transition :new => :received
    end
    
    event :install do
      transition :received => :installed
    end
    
    event :approve_registration do
      transition :whamd_registered => :installed
    end
    
    event :make_in_service do
      transition any => :in_service
    end
    
    event :make_out_of_service do
      transition :in_service => :out_of_service
    end
    
    event :decommission do
      transition any => :decommissioned
    end
    
    event :dispose do
      transition any => :disposed
    end
    
    state :new do
    end
    
    state :whamd_registered do
    end
    
    state :received do
      validates_presence_of :serial, :message => "Received assets must have their serials logged"
    end
    
    state :installed do    
    end
    
    state :in_service do
    end
    
    state :out_of_service do
    end
    
    state :decommissioned do
    end
    
    state :disposed do
    end
  end
  
  # Class methods

  # Provides select options for forms
  def self.select_options
    subclasses.map{ |c| c.to_s }.sort
  end
  
  def self.per_page
    30
  end
  
  
  # Instance methods
  # Getter for an asset's FQDN
  def fqdn
    [ hostname, domain ].join('.') unless hostname.nil? and domain.nil?
  end
  
  # Getter for an asset's location
  def location
    [equipment_rack.room.building.name, equipment_rack.room.name, equipment_rack.name, "Unit #{rack_elevation}"].join(', ') unless equipment_rack.nil?
  end
  
  def ping
    Asset.paper_trail_off   # We don't want pings cluttering up the version table
    update_attribute(:last_seen, Time.now)
    Asset.paper_trail_on
  end
  
  def rack_unit_range
    ru = hardware_model.rackunits if hardware_model
    ru = rack_units if rack_units
    rack_elevation..(rack_elevation+ru-1) if rack_elevation && ru
  end
  
  def is_top_unit?(unit)
    ru = hardware_model.rackunits if hardware_model
    ru = rack_units if rack_units
    ((rack_elevation+ru-1) == unit) ? true : false
  end
  
  # For grouped pagination
  before_save :update_group_letter
  def update_group_letter
    self.first_letter = name[0,1]
  end
  
  def active?
    (ACTIVE_STATES.include? state.to_sym) ? true : false
  end
  
  def inactive?
    !active?
  end
end




# == Schema Information
#
# Table name: assets
#
#  id                :integer(4)      not null, primary key
#  name              :string(255)
#  description       :string(255)
#  serial            :string(255)
#  wb_asset_id       :string(255)
#  hardware_id       :integer(4)
#  group_id          :integer(4)
#  farm_id           :integer(4)
#  equipment_rack_id :integer(4)
#  rack_elevation    :integer(4)
#  rack_units        :integer(4)
#  purchase_date     :date
#  vendor_id         :integer(4)
#  leased            :boolean(1)
#  sap_asset_id      :string(255)
#  sap_wbs_element   :string(255)
#  monitorable       :boolean(1)
#  created_at        :datetime
#  updated_at        :datetime
#  state             :string(255)
#  hostname          :string(255)
#  domain            :string(255)
#  type              :string(255)     default("Asset")
#  building_id       :integer(4)
#  room_id           :integer(4)
#

