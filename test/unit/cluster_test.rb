require 'test_helper'

class ClusterTest < ActiveSupport::TestCase
  should have_many :sites
  should have_many :apps_clusters
  should have_many :apps
  should have_many :services
  should have_many :assets
  should have_many :parameters
  should have_many :parameter_assignments
  
  should validate_presence_of :name
  should validate_uniqueness_of :name
  
  context 'A cluster' do
    setup do
      @cluster = Factory(:cluster)
    end

    should 'be valid' do
      assert @cluster.valid?
    end
    
    should 'be active by default' do
      assert @cluster.active?
    end
    
    context 'that has been deactivated' do
      setup do
        @cluster.deactivate
      end
      
      should 'be inactive' do
        assert @cluster.inactive?
      end
    end
  end
end


# == Schema Information
#
# Table name: clusters
#
#  id          :integer(4)      not null, primary key
#  name        :string(255)
#  description :string(255)
#  state       :string(255)     default("active")
#  created_at  :datetime
#  updated_at  :datetime
#

