require 'test_helper'

class VipTest < ActiveSupport::TestCase
  should belong_to :load_balancer
  should belong_to :ip
  should have_many :sites
  
  should have_many :vips_assets
  should have_many :assets, :through => :vips_assets
  
  should validate_presence_of :name, :message => "VIP name can't be blank"
  should validate_presence_of :ip_id, :message => "VIP IP can't be blank"
  
  context 'A vip' do
    setup do
      @vip = Factory(:vip)
    end

    should 'be valid' do
      assert @vip.valid?
    end
    
    should 'be active by default' do
      assert @vip.active?
    end
    
    context 'that has been deactivated' do
      setup do
        @vip.deactivate
      end
      
      should 'be inactive' do
        assert @vip.inactive?
      end
    end
  end
end

# == Schema Information
#
# Table name: vips
#
#  id          :integer(4)      not null, primary key
#  name        :string(255)
#  description :string(255)
#  ip_id       :integer(4)
#  notes       :text
#  state       :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

