class ServiceAssignment < ActiveRecord::Base
  attr_accessible :service, :service_id
  attr_accessible :cluster, :cluster_id, :function, :function_id
  
  # ServiceAssignments are like the old WHAM's deviceservices
  belongs_to :asset
  belongs_to :service

  has_many :parameter_assignments, :as => :assignable
  has_many :parameters, :through => :parameter_assignments

  # We don't want the same service assigned twice to a single asset
  validates_uniqueness_of :service_id, :scope => :asset_id, :message => "That service has already been assigned to this asset"
  
  # Nested models
  before_validation :set_service_id
  def set_service_id
    self.service = Service.find_or_create_by_cluster_id_and_function_id(service.cluster_id, service.function_id) if service
  end
  attr_accessible :service_attributes
  accepts_nested_attributes_for :service,
                                :reject_if => lambda { |a| (a[:cluster_id].blank? || a[:function_id].blank?) },
                                :allow_destroy => false
  validates_associated :service
  
  has_paper_trail :meta => { :asset_id => Proc.new { |a| a.asset_id }}
  
  # def cluster
  #   service.cluster unless service.nil?
  # end
  # def cluster=(cluster)
  #   self.service = Service.find_or_create_by_cluster_id_and_function_id(cluster, function) unless function.nil?
  # end
  attr_accessor :cluster_id
  def cluster_id
    if service.nil?
      @_cluster_id
    else
      service.cluster_id
    end
  end
  def cluster_id=(cluster_id)
    @_cluster_id = cluster_id
    self.service = Service.find_or_create_by_cluster_id_and_function_id(cluster_id, function_id) unless function_id.nil?
  end
  
  # def function
  #   service.function unless service.nil?
  # end
  # def function=(function)
  #   service = Service.find_or_create_by_cluster_id_and_function_id(cluster, function) unless cluster.nil?
  # end
  attr_accessor :function_id
  def function_id
    if service.nil?
      @_function_id
    else
      service.function_id
    end
  end
  def function_id=(function_id)
    @_function_id = function_id
    self.service = Service.find_or_create_by_cluster_id_and_function_id(cluster_id, function_id) unless cluster_id.nil?
  end
end

# == Schema Information
#
# Table name: service_assignments
#
#  id         :integer(4)      not null, primary key
#  asset_id   :integer(4)
#  service_id :integer(4)
#  created_at :datetime
#  updated_at :datetime
#

