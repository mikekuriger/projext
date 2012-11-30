require 'test_helper'

class CableTest < ActiveSupport::TestCase
  should belong_to :interface
  should belong_to :interface_target
  should belong_to :medium
  
  should validate_presence_of :interface
  should validate_presence_of :interface_target
end

# == Schema Information
#
# Table name: cables
#
#  id                :integer(4)      not null, primary key
#  from_interface_id :integer(4)
#  to_interface_id   :integer(4)
#  medium_id         :integer(4)
#  created_at        :datetime
#  updated_at        :datetime
#

