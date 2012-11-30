class Project < ActiveRecord::Base
  attr_accessible :name, :description, :customer, :customer_id

  # By default, we want records ordered by name, ascending
  default_scope :order => 'name ASC'

  belongs_to :customer
  
  has_many :apps

  validates_presence_of :name, :message => "Project name cannot be blank"
  validates_presence_of :customer_id, :message => "Customer cannot be blank"

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
