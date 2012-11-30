require 'test_helper'

class CpuTest < ActiveSupport::TestCase
  should_belong_to :manufacturer
  should_have_many :assets
  
  # should_validate_presence_of :manufacturer_id, :message => "Manufacturer can't be blank"
  should_validate_presence_of :cpu_type, :message => "CPU type can't be blank"
  # should_validate_presence_of :cores, :message => "Cores can't be blank"
  # should_validate_presence_of :speed, :message => "Speed can't be blank"
  
  should_validate_uniqueness_of :speed, :scoped_to => [ :manufacturer_id, :cpu_type, :cores ], :message => "Duplicate CPU"
end
