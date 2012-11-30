class Manufacturer < ActiveRecord::Base
  attr_accessible :name, :address1, :address2, :city, :state, :zip, :url, :notes

  # By default, we want records ordered by name, ascending
  default_scope :order => 'name ASC'
  
  has_many :hardware_models
  has_many :assets, :through => :hardware_models
  
  validates_presence_of :name, :message => "Manufacturer name can't be blank"
  validates_uniqueness_of :name
  
  # Enable comments
  acts_as_commentable
end
