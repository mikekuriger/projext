require 'test_helper'

class ManufacturerTest < ActiveSupport::TestCase
  should_have_many :hardware_models
  should_have_many :assets
  
  should_validate_presence_of :name, :message => "Manufacturer name can't be blank"
  should_validate_uniqueness_of :name
end
