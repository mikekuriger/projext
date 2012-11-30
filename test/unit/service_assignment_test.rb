require 'test_helper'

class ServiceAssignmentTest < ActiveSupport::TestCase
  should belong_to :asset, :service
  should have_many :parameter_assignments
  should have_many :parameters

  should validate_uniqueness_of :service_id, :scoped_to => :asset_id, :message => "That service has already been assigned to this asset"
end

# == Schema Information
#
# Table name: service_assignments
#
#  id         :integer(4)      not null, primary key
#  asset_id   :integer(4)
#  service_id :integer(4)
#  created_at :datetime
#  updated_at :datetime
#

