class StorageShelf < Asset
  attr_accessible :name, :hostname, :domain, :serial, :hardware_model_id, :group_id, :farm_id, :equipment_rack_id, :disk_size, :disk_type, :disk_count

  belongs_to :storage_array
  has_many :storage_heads, :through => :storage_array
  
  validates_inclusion_of :disk_type, :in => [ '', 'FC', 'SATA', 'SAS' ]
  
  has_paper_trail
  
  DISK_TYPE_OPTIONS = [
      ['FC', 'FC'],
      ['SATA', 'SATA'],
      ['SAS', 'SAS']
    ]
end
