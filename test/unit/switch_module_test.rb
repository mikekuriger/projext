require 'test_helper'

class SwitchModuleTest < ActiveSupport::TestCase
  should_belong_to :hardware_model
  should_belong_to :switch
end
