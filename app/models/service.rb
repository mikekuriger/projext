class Service < ActiveRecord::Base
  attr_accessible :cluster, :function, :cluster_id, :function_id, :cluster_name, :function_name, :state, :asset_ids
  
  # So that Service.active, Service.inactive, etc. will work
  named_scope :active, :conditions => { :state => 'active' }
  named_scope :inactive, :conditions => { :state => 'inactive' }  
  
  belongs_to :cluster
  belongs_to :function
  
  has_many :service_assignments
  has_many :assets, :through => :service_assignments
  
  has_many :sites, :through => :cluster
  
  has_many :parameter_assignments, :as => :assignable
  has_many :parameters, :through => :parameter_assignments

  validates_presence_of :cluster_id, :message => "A service must have a cluster"
  validates_presence_of :function_id, :message => "A service must have a function"
  
  validates_uniqueness_of :cluster_id, :scope => :function_id, :message => "Service already exists"
  
  has_paper_trail
  
  # Search indexing via Thinking Sphinx
  define_index do
    indexes cluster(:name), :as => :cluster, :sortable => true
    indexes function(:name), :as => :function, :sortable => true
    indexes cluster.description
    indexes function.description
    
    set_property :min_infix_len => 2    # Minimum number of characters to index as an infix
    set_property :infix_fields => 'name, description'   # Only do infix indexing for specific fields
    # set_property :delta => true
  end
  
  state_machine :initial => :active do
    event :deactivate do
      transition :active => :inactive
    end

    event :activate do
      transition :inactive => :active
    end

    state :active do
    end

    state :inactive do
    end
  end
  
  # Class methods
  

  # Instance methods
  def to_s
    "#{cluster.name}:#{function.name}" if (cluster && function)
  end
  
  def cluster_name
    cluster.name if cluster
  end
  def cluster_name=(name)
    self.cluster = Cluster.find_or_create_by_name(name) unless name.blank?
  end
  def function_name
    function.name if function
  end
  def function_name=(name)
    self.function = Function.find_or_create_by_name(name) unless name.blank?
  end
end


# == Schema Information
#
# Table name: services
#
#  id          :integer(4)      not null, primary key
#  cluster_id  :integer(4)
#  function_id :integer(4)
#  state       :string(255)     default("active")
#  created_at  :datetime
#  updated_at  :datetime
#

