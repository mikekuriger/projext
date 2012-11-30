class Operatingsystem < ActiveRecord::Base
  attr_accessible :name, :description, :manufacturer, :manufacturer_id, :ostype, :version, :architecture
  
  belongs_to :manufacturer
  
  has_many :assets
  
  validates_presence_of :name, :message => "Operating system must have a name"
  validates_presence_of :manufacturer_id, :message => "Operating system manufacturer can't be blank"
  validates_presence_of :ostype, :message => "Operating system type can't be blank"
end
