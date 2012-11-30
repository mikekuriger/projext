class Assignment < ActiveRecord::Base
  belongs_to :user
  belongs_to :role
  
  has_paper_trail
end

# == Schema Information
#
# Table name: assignments
#
#  id         :integer(4)      not null, primary key
#  user_id    :integer(4)
#  role_id    :integer(4)
#  created_at :datetime
#  updated_at :datetime
#

