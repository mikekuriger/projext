require 'test_helper'

class RoleTest < ActiveSupport::TestCase
  should have_many :assignments, :users
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

