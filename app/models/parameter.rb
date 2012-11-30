class Parameter < ActiveRecord::Base
  attr_accessible :name, :description, :state

  validates_presence_of :name, :message => "Parameter name can't be blank"
  validates_uniqueness_of :name, :message => "Parameter name must be unique"
  
  has_many :parameter_assignments
  
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
