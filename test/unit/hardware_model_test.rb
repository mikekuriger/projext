require 'test_helper'

class HardwareModelTest < ActiveSupport::TestCase
  should belong_to :manufacturer
  
  should validate_presence_of :name
  
  should have_attached_file :picture
  should have_attached_file :rack_front
  should have_attached_file :rack_rear
end
