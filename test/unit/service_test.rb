require 'test_helper'

class ServiceTest < ActiveSupport::TestCase
  should_belong_to :cluster, :function
  should_have_many :service_assignments, :assets, :sites
  
  should_validate_presence_of :cluster_id, :message => "A service must have a cluster"
  should_validate_presence_of :function_id, :message => "A service must have a function"
  should_validate_uniqueness_of :cluster_id, :scoped_to => :function_id, :message => "Service already exists"

  context 'A service' do
    setup do
      @service = Factory(:service)
    end

    should 'be valid' do
      assert @service.valid?
    end
    
    should 'be active by default' do
      assert @service.active?
    end
    
    context 'that has been deactivated' do
      setup do
        @service.deactivate
      end
      
      should 'be inactive' do
        assert @service.inactive?
      end
    end
  end
end


# == Schema Information
#
# Table name: services
#
#  id          :integer(4)      not null, primary key
#  cluster_id  :integer(4)
#  function_id :integer(4)
#  state       :string(255)     default("active")
#  created_at  :datetime
#  updated_at  :datetime
#

