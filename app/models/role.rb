class Role < ActiveRecord::Base
  has_many :assignments
  has_many :users, :through => :assignments
  
  has_paper_trail
end

# == Schema Information
#
# Table name: roles
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

