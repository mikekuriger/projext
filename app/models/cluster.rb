class Cluster < ActiveRecord::Base
  attr_accessible :name, :description, :state, :app_ids

  has_many :sites
  has_many :apps_clusters
  has_many :apps, :through => :apps_clusters
  
  has_many :services
  has_many :assets, :through => :services

  has_many :parameter_assignments, :as => :assignable
  has_many :parameters, :through => :parameter_assignments
  
  # By default, we want records ordered by name, ascending
  default_scope :order => 'name ASC'
  
  named_scope :active, :conditions => {:state => 'active'}
  named_scope :inactive, :conditions => {:state => 'inactive'}
    
  validates_presence_of :name, :message => "Cluster name can't be blank"
  validates_uniqueness_of :name, :message => "Cluster name must be unique"
  
  has_paper_trail
  
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
end


# == Schema Information
#
# Table name: clusters
#
#  id          :integer(4)      not null, primary key
#  name        :string(255)
#  description :string(255)
#  state       :string(255)     default("active")
#  created_at  :datetime
#  updated_at  :datetime
#

