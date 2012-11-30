require 'test_helper'

class EquipmentRackTest < ActiveSupport::TestCase
  should belong_to :room
  should have_many :assets
  
  should validate_presence_of :name
  
  context 'An equipment_rack' do
    setup do
      @equipment_rack = Factory(:equipment_rack)
    end

    should 'be valid' do
      assert @equipment_rack.valid?
    end
    
    should 'be active by default' do
      assert @equipment_rack.active?
    end
    
    context 'that has been deactivated' do
      setup do
        @equipment_rack.deactivate
      end
      
      should 'be inactive' do
        assert @equipment_rack.inactive?
      end
    end
  end
end

# == Schema Information
#
# Table name: equipment_racks
#
#  id          :integer(4)      not null, primary key
#  room_id     :integer(4)
#  name        :string(255)
#  description :string(255)
#  state       :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

