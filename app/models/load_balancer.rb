class LoadBalancer < Asset
  attr_accessible :name, :hostname, :domain, :serial, :hardware_model_id, :group_id, :farm_id, :equipment_rack_id

  has_many :vips
  
  has_paper_trail
end
