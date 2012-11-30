require 'test_helper'

class CpuTest < ActiveSupport::TestCase
  should belong_to :manufacturer
  should have_many :assets
  
  # should validate_presence_of :manufacturer_id, :message => "Manufacturer can't be blank"
  should validate_presence_of :cpu_type
  # should validate_presence_of :cores, :message => "Cores can't be blank"
  # should validate_presence_of :speed, :message => "Speed can't be blank"
  
  should validate_uniqueness_of :speed
end
