class NetworkingDevice < Asset
  attr_accessible :name, :hostname, :domain, :serial, :hardware_model_id, :group_id, :farm_id, :equipment_rack_id

  has_paper_trail
  
  def self.all
    Asset.all(:conditions => ['type = ? OR type = ? OR type = ? OR type = ?', 'Switch', 'Firewall', 'LoadBalancer', 'Router'])
  end
end
