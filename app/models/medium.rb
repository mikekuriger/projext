class Medium < ActiveRecord::Base
  attr_accessible :name, :description, :state
  
  has_many :cables
  
  validates_presence_of :name, :message => "Medium name can't be blank"
end

# == Schema Information
#
# Table name: media
#
#  id          :integer(4)      not null, primary key
#  name        :string(255)
#  description :string(255)
#  state       :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

