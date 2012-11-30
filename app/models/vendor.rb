class Vendor < ActiveRecord::Base
  attr_accessible :name, :address1, :address2, :city, :state, :zip, :country, :url, :notes
  
  has_many :contracts
  
  validates_presence_of :name, :message => "Vendor name can't be blank"
  
  # By default, we want records ordered by name, ascending
  default_scope :order => 'name ASC'
  
  # Enable commenting
  acts_as_commentable
  
  has_paper_trail
end

# == Schema Information
#
# Table name: vendors
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  address1   :string(255)
#  address2   :string(255)
#  city       :string(255)
#  state      :string(255)
#  zip        :string(255)
#  country    :string(255)
#  url        :string(255)
#  notes      :text
#  created_at :datetime
#  updated_at :datetime
#

