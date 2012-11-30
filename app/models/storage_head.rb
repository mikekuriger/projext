class StorageHead < Asset
  attr_accessible :name, :hostname, :domain, :serial, :hardware_model_id, :group_id, :farm_id, :equipment_rack_id

  belongs_to :storage_array
  has_many :storage_shelves, :through => :storage_array
  
  has_paper_trail
end
