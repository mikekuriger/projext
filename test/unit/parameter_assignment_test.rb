require 'test_helper'

class ParameterAssignmentTest < ActiveSupport::TestCase
  should belong_to :assignable
  should belong_to :parameter
  
  context 'A parameter assignment' do
    setup do
      @parameter_assignment = Factory(:parameter_assignment, { :parameter => Factory(:parameter, { :name => 'unittesting' }), :value => '5' })
    end

    should 'display the correct name and value' do
      assert_equal @parameter_assignment.parameter.name, 'unittesting'
      assert_equal @parameter_assignment.value, '5'
    end
  end
end
