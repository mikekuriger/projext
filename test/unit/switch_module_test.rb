require 'test_helper'

class SwitchModuleTest < ActiveSupport::TestCase
  should belong_to :hardware_model
  should belong_to :switch
end
