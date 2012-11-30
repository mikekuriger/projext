class VirtualServer < Server
  attr_accessible :name, :description, :parent_id, :parent_name

  attr_accessor :parent_name
  
  belongs_to :parent, :class_name => 'Server'
  
  # From friendly_id plugin (http://github.com/norman/friendly_id)
  has_friendly_id :fqdn, :use_slug => true
  
  # has_paper_trail
  
  # before_validation :set_service_ids
  # def set_service_ids
  #   self.services = services.collect{|s| Service.find_or_create_by_cluster_id_and_function_id(s.cluster_id, s.function_id)} if services
  # end
  
  # attr_accessible :services_attributes
  # accepts_nested_attributes_for :services,
  #                               :reject_if => lambda { |a| (a[:cluster_id].blank? || a[:function_id].blank?) },
  #                               :allow_destroy => true
  # validates_associated :services
end
