class Switch < Asset
  # Attributes
  attr_accessible :name, :hostname, :domain, :serial, :hardware_model_id, :group_id, :farm_id, :equipment_rack_id
  attr_accessible :interfaces_attributes
  attr_accessible :switch_modules_attributes

  # By default, we want records ordered by name, ascending
  default_scope :order => 'hostname ASC'

  # Relationships
  has_many :switch_modules, :foreign_key => 'switch_id', :dependent => :restrict

  # Nested attributes
  accepts_nested_attributes_for :interfaces,
                                :reject_if => lambda { |a| a[:name].blank? },
                                :allow_destroy => true
                                
  accepts_nested_attributes_for :switch_modules,
                                :reject_if => lambda { |a| a[:name].blank? },
                                :allow_destroy => true
  
  # Validations
  validates_associated :interfaces
  validates_associated :switch_modules
  validates_presence_of :hostname, :message => "Switch hostname can't be blank"
  validates_uniqueness_of :hostname, :scope => :domain, :message => "Hostname must be unique"
end
