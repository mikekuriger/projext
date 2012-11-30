require 'test_helper'

class ParameterTest < ActiveSupport::TestCase
  subject { Factory(:parameter) }
  should_validate_presence_of :name, :message => "Parameter name can't be blank"
  should_validate_uniqueness_of :name, :message => "Parameter name must be unique"

  context 'A parameter' do
    setup do
      @parameter = Factory(:parameter)
    end

    should 'be valid' do
      assert @parameter.valid?
    end
    
    should 'be active by default' do
      assert @parameter.active?
    end
    
    context 'that has been deactivated' do
      setup do
        @parameter.deactivate
      end
      
      should 'be inactive' do
        assert @parameter.inactive?
      end
    end
  end
end
