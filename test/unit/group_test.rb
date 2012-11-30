require 'test_helper'

class GroupTest < ActiveSupport::TestCase
  should have_many :assets
  should have_many :servers
  should have_many :switches
  should have_many :routers
  should have_many :firewalls
  should have_many :load_balancers
  should have_many :storage_heads
  should have_many :storage_shelves
  should have_many :storage_arrays
  should have_many :equipment_racks
  
  should validate_presence_of :name
  should validate_uniqueness_of :name
  
  context 'A group' do
    setup do
      @group = Factory(:group)
    end

    should 'be valid' do
      assert @group.valid?
    end
    
    should 'be active by default' do
      assert @group.active?
    end
    
    context 'that has been deactivated' do
      setup do
        @group.deactivate
      end
      
      should 'be inactive' do
        assert @group.inactive?
      end
    end
  end
end

# == Schema Information
#
# Table name: groups
#
#  id          :integer(4)      not null, primary key
#  name        :string(255)
#  description :string(255)
#  state       :string(255)     default("active")
#  created_at  :datetime
#  updated_at  :datetime
#

