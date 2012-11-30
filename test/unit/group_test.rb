require 'test_helper'

class GroupTest < ActiveSupport::TestCase
  should_have_many :assets, :servers, :switches, :routers, :firewalls, :load_balancers, :storage_heads, :storage_shelves, :storage_arrays
  should_have_many :equipment_racks, :through => :assets
  
  should_validate_presence_of :name, :message => "Group name can't be blank"
  should_validate_uniqueness_of :name, :message => "Group name must be unique"
  
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

