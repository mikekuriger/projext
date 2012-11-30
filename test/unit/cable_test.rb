require 'test_helper'

class CableTest < ActiveSupport::TestCase
  should_belong_to :interface, :interface_target
  should_belong_to :medium
  
  should_validate_presence_of :interface, :message => "Source interface must exist"
  should_validate_presence_of :interface_target, :message => "Target interface must exist"
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

