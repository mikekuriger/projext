require 'test_helper'

class ClusterTest < ActiveSupport::TestCase
  should_have_many :sites
  should_have_many :apps_clusters
  should_have_many :apps
  should_have_many :services
  should_have_many :assets
  should_have_many :parameters
  should_have_many :parameter_assignments
  
  should_validate_presence_of :name, :message => "Cluster name can't be blank"
  should_validate_uniqueness_of :name, :message => "Cluster name must be unique"
  
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

