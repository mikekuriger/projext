require 'test_helper'

class InterfaceTest < ActiveSupport::TestCase
  should_belong_to :asset
  should_belong_to :ip

  should_have_one :cable
  
  should_validate_presence_of :name, :message => "Interface name can't be blank"

  should_allow_values_for :mac, "00:00:00:00:00:00", "DE:AD:BE:EF:FF:FF"
  should_not_allow_values_for :mac, "00:00", "blarg", "GG:GG:GG:GG:GG:GG"
end


# == Schema Information
#
# Table name: interfaces
#
#  id           :integer(4)      not null, primary key
#  name         :string(255)
#  description  :string(255)
#  state        :string(255)
#  asset_id     :integer(4)
#  ip_id        :integer(4)
#  speed        :string(255)
#  mac          :string(255)
#  connector_id :integer(4)
#  created_at   :datetime
#  updated_at   :datetime
#  cable_id     :integer(4)
#

