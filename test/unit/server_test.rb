require 'test_helper'

class ServerTest < ActiveSupport::TestCase
  # Some of these tests probably aren't necessary, since they are being done at the asset level
  should_validate_presence_of :name, :message => "Asset name can't be blank"
  
  # should_validate_presence_of :hostname, :message => "Server hostname can't be blank"
  # should_validate_presence_of :domain, :message => "Server domain can't be blank"
  # should_validate_uniqueness_of :hostname, :scoped_to => :domain, :message => "Hostname must be unique"
  
  should_belong_to :agent

  context 'A server' do
    setup do
      @server = Factory(:server, :hostname => 'testserver', :domain => 'warnerbros.com')
    end

    should 'have the correct FQDN' do
      assert_equal @server.fqdn, 'testserver.warnerbros.com'
    end
    
    should 'be in the new state' do
      assert_equal @server.state, 'new'
    end
    
    context 'with no serial' do
      setup do
        @server.serial = nil
      end
      should 'not allow transition to received state' do
        @server.receive
        assert_equal @server.state, 'new'
      end
    end
    
    context 'with a serial' do
      setup do
        @server.serial = '123456'
      end
      should 'allow transition to received state' do
        @server.receive
        assert_equal @server.state, 'received'
      end
    end
    
    context 'that has been received' do
      setup do
        @server = Factory(:server)
        @server.receive
      end
      should 'have a serial' do
        assert @server.serial
      end
      
      should 'allow transition to installed state' do
        @server.install
        assert_equal @server.state, 'installed'
      end
    end
    
    context 'that has been installed' do
      # should 'have a location' do
      # end
      
      should 'allow transition to in_service state' do
        @server.make_in_service
        assert_equal @server.state, 'in_service'
      end
    end
    
    context 'that is in service' do
      setup do
        @server = Factory(:server)
        @server.receive
        @server.install
        @server.make_in_service
      end
      should 'allow transition to out_of_service state' do
        @server.make_out_of_service
        assert_equal @server.state, 'out_of_service'
      end
    end
    
    context 'that is out of service' do
      should 'allow transition to decommissioned state' do
        @server.decommission
        assert_equal @server.state, 'decommissioned'
      end
    end
    
    context 'that is decommissioned' do
      should 'allow transition to disposed state' do
        @server.dispose
        assert_equal @server.state, 'disposed'
      end
    end
  end 
end



# == Schema Information
#
# Table name: assets
#
#  id                :integer(4)      not null, primary key
#  name              :string(255)
#  description       :string(255)
#  serial            :string(255)
#  wb_asset_id       :string(255)
#  hardware_id       :integer(4)
#  group_id          :integer(4)
#  farm_id           :integer(4)
#  equipment_rack_id :integer(4)
#  rack_elevation    :integer(4)
#  rack_units        :integer(4)
#  purchase_date     :date
#  vendor_id         :integer(4)
#  leased            :boolean(1)
#  sap_asset_id      :string(255)
#  sap_wbs_element   :string(255)
#  monitorable       :boolean(1)
#  created_at        :datetime
#  updated_at        :datetime
#  state             :string(255)
#  hostname          :string(255)
#  domain            :string(255)
#  type              :string(255)     default("Asset")
#  building_id       :integer(4)
#  room_id           :integer(4)
#

