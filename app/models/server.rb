class Server < Asset
  attr_accessible :name, :description, :serial, :hostname, :domain, :wb_asset_id, :hardware_model, :hardware_model_id,
                  :group, :group_id, :farm, :farm_id, :equipment_rack, :equipment_rack_id, :rack_elevation, :rack_units,
                  :purchase_date, :vendor_id, :backup, :leased, :sap_asset_id, :sap_wbs_element, :monitorable, :state, :cpu_count,
                  :agent_id, :operatingsystem_id, :virtualization_host, :backup
  attr_accessible :created_at, :vm_memory_static_min, :delta, :first_letter, :modular, :updated_at, :vm_vcpus_at_startup, :disk_size, :disk_count, :vm_memory_dynamic_max, :id, :interfaces, :last_seen, :storage_array_id, :parent_id, :cached_slug, :vm_memory_dynamic_min, :services, :disk_type, :vm_memory_static_max, :vm_memory_target, :switch_id, :vm_vcpus_max

  # By default, we want records ordered by name, ascending
  default_scope :order => 'hostname ASC'

  has_many :virtual_servers, :foreign_key => 'parent_id'
  belongs_to :agent
  
  # From friendly_id plugin (http://github.com/norman/friendly_id)
  has_friendly_id :fqdn, :use_slug => true
  
  before_validation :set_default_domain
  def set_default_domain
    self.domain = 'warnerbros.com' unless attribute_present?('domain')
  end
  
  validates_presence_of :hostname, :message => "Server hostname can't be blank"
  validates_presence_of :domain, :message => "Server domain can't be blank"
  validates_uniqueness_of :hostname, :scope => :domain, :message => "Hostname must be unique"
  
  attr_accessible :service_assignments_attributes
  accepts_nested_attributes_for :service_assignments,
                                # :reject_if => lambda { |a| (a[:cluster_id].blank? || a[:function_id].blank?) },
                                :allow_destroy => true
  validates_associated :service_assignments

  def self.per_page
    30
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
#  backup            :boolean(1)
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

