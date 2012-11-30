class Email < ActiveRecord::Base
  attr_accessible :name, :domain_id, :project_id
  
  belongs_to :domain
  belongs_to :project
  
  has_many :emails_aliases
  has_many :aliases, :through => :emails_aliases
end
