require 'test_helper'

class ManufacturerTest < ActiveSupport::TestCase
  should have_many :hardware_models
  should have_many :assets
  
  should validate_presence_of :name, :message => "Manufacturer name can't be blank"
  should validate_uniqueness_of :name
end
