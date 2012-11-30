class Group < ActiveRecord::Base
  attr_accessible :name, :description, :state, :asset_ids
  
  has_many :assets
  has_many :equipment_racks, :through => :assets
  has_many :servers, :dependent => :restrict
  has_many :virtual_servers, :dependent => :restrict
  has_many :switches, :dependent => :restrict
  has_many :routers, :dependent => :restrict
  has_many :firewalls, :dependent => :restrict
  has_many :load_balancers, :dependent => :restrict
  has_many :storage_heads, :dependent => :restrict
  has_many :storage_shelves, :dependent => :restrict
  has_many :storage_arrays, :dependent => :restrict
  
  # By default, we want records ordered by name, ascending
  default_scope :order => 'name ASC'
  
  named_scope :active, :conditions => {:state => 'active'}
  
  validates_presence_of :name, :message => "Group name can't be blank"
  validates_uniqueness_of :name, :message => "Group name must be unique"
  
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
  
  attr_reader :asset_count
  def asset_count
    assets.size
  end
end

# == Schema Information
#
# Table name: groups
#
#  id          :integer(4)      not null, primary key
#  name        :string(255)
#  description :string(255)
#  state       :string(255)     default("active")
#  created_at  :datetime
#  updated_at  :datetime
#

