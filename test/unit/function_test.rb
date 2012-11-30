require 'test_helper'

class FunctionTest < ActiveSupport::TestCase
  should_have_many :services
  should_have_many :assets
  should_have_many :parameter_assignments
  should_have_many :parameters
  
  should_validate_presence_of :name, :message => "Function name can't be blank"
  should_validate_uniqueness_of :name, :message => "Function name must be unique"
  
  context 'A function' do
    setup do
      @function = Factory(:function)
    end

    should 'be valid' do
      assert @function.valid?
    end
    
    should 'be active by default' do
      assert @function.active?
    end
    
    context 'that has been deactivated' do
      setup do
        @function.deactivate
      end
      
      should 'be inactive' do
        assert @function.inactive?
      end
    end
  end
end


# == Schema Information
#
# Table name: functions
#
#  id          :integer(4)      not null, primary key
#  name        :string(255)
#  description :string(255)
#  state       :string(255)     default("active")
#  created_at  :datetime
#  updated_at  :datetime
#

