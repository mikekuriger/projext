require 'test_helper'

class AssetTest < ActiveSupport::TestCase
  should belong_to :group
  should belong_to :farm
  should belong_to :hardware_model
  should belong_to :equipment_rack
  should belong_to :vendor
  should belong_to :cpu

  should have_many :service_assignments
  should have_many :services
  should have_many :functions
  should have_many :clusters
  should have_many :sites
  should have_many :ips
  
  should have_many :interfaces
  should have_many :cables
  
  should have_many :vips_assets
  should have_many :vips
  
  should have_many :parameter_assignments
  should have_many :parameters
  
  should have_many :assets_contracts
  should have_many :contracts
  
  should validate_presence_of :name
  #should validate_uniqueness_of :name, :message => "Asset name must be unique"
  # should validate_presence_of :serial, :message => "Asset serial can't be blank"
  # should validate_uniqueness_of :serial, :message => "Asset serial must be unique"
  
  context 'An asset' do
    setup do
      @asset = Factory(:asset, :hostname => 'testasset', :domain => 'warnerbros.com')
    end

    should 'have the correct FQDN' do
      assert_equal @asset.fqdn, 'testasset.warnerbros.com'
    end
    
    should 'be in the new state' do
      assert_equal @asset.state, 'new'
    end
    
    context 'with no serial' do
      setup do
        @asset.serial = nil
      end
      should 'not allow transition to received state' do
        @asset.receive
        assert_equal @asset.state, 'new'
      end
    end
    
    context 'with a serial' do
      setup do
        @asset.serial = '123456'
      end
      should 'allow transition to received state' do
        @asset.receive
        assert_equal @asset.state, 'received'
      end
    end
    
    context 'that has been received' do
      setup do
        @asset = Factory(:asset)
        @asset.receive
      end
      should 'have a serial' do
        assert @asset.serial
      end
      
      should 'allow transition to installed state' do
        @asset.install
        assert_equal @asset.state, 'installed'
      end
    end
    
    context 'that has been installed' do
      # should 'have a location' do
      # end
      
      should 'allow transition to in_service state' do
        @asset.make_in_service
        assert_equal @asset.state, 'in_service'
      end
    end
    
    context 'that is in service' do
      setup do
        @asset = Factory(:asset)
        @asset.receive
        @asset.install
        @asset.make_in_service
      end
      should 'allow transition to out_of_service state' do
        @asset.make_out_of_service
        assert_equal @asset.state, 'out_of_service'
      end
    end
    
    context 'that is out of service' do
      should 'allow transition to decommissioned state' do
        @asset.decommission
        assert_equal @asset.state, 'decommissioned'
      end
    end
    
    context 'that is decommissioned' do
      should 'allow transition to disposed state' do
        @asset.dispose
        assert_equal @asset.state, 'disposed'
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

