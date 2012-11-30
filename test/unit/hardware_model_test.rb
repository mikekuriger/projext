require 'test_helper'

class HardwareModelTest < ActiveSupport::TestCase
  should_belong_to :manufacturer
  
  should_validate_presence_of :name, :message => "Hardware model name can't be blank"
  
  should_have_attached_file :picture
  should_have_attached_file :rack_front
  should_have_attached_file :rack_rear
end
