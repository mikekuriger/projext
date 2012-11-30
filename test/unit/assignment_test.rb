require 'test_helper'

class AssignmentTest < ActiveSupport::TestCase
  should_belong_to :user, :role
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

