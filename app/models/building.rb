class Building < ActiveRecord::Base
  attr_accessible :name, :description, :address1, :address2, :city, :state, :zip, :country
  
  has_many :rooms
  # has_many :assets
  
  # By default, we want records ordered by name, ascending
  default_scope :order => 'name ASC'
  
  validates_presence_of :name, :message => "Building name can't be blank"
  validates_uniqueness_of :name, :message => "Building name must be unique"
  
  has_paper_trail
end

# == Schema Information
#
# Table name: buildings
#
#  id          :integer(4)      not null, primary key
#  name        :string(255)
#  description :string(255)
#  address1    :string(255)
#  address2    :string(255)
#  city        :string(255)
#  state       :string(255)
#  zip         :string(255)
#  country     :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

