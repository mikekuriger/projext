require 'test_helper'

class NetworkTest < ActiveSupport::TestCase
  should have_many :ips
  should belong_to :farm
  
  should validate_presence_of :network, :message => "Network must exist"
  should validate_presence_of :subnetbits, :message => "Subnet bits must exist"

  should allow_values_for :network, "10.1.0.0", "192.168.1.0"
  should not_allow_values_for :network, "blah", "256.1.1.1", "10.256.0.0", "192.168.1.256", "192.168.x.y"
  
  context 'A network' do
    setup do
      @network = Factory(:network, :network => '192.168.10.0', :subnetbits => 24)
#      @network = Network.create(:network => '192.168.10.0', :subnetbits => 24)
    end

    should 'have the correct broadcast address' do
      assert_equal @network.broadcast, '192.168.10.255'
    end
    
    should 'have the correct netmask' do
      assert_equal @network.netmask, '255.255.255.0'
    end
  end
end

# == Schema Information
#
# Table name: networks
#
#  id          :integer(4)      not null, primary key
#  farm_id     :integer(4)
#  network     :string(255)
#  subnetbits  :integer(4)
#  netmask     :string(255)
#  gateway     :string(255)
#  vlan        :string(255)
#  description :string(255)
#  notes       :text
#  created_at  :datetime
#  updated_at  :datetime
#

