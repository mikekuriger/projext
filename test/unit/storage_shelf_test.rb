require 'test_helper'

class StorageShelfTest < ActiveSupport::TestCase
  should_belong_to :storage_array
  should_have_many :storage_heads, :through => :storage_array
  
  should_allow_values_for :disk_type, "FC", "SATA", "SAS"
  should_not_allow_values_for :disk_type, "foo", "baz", "blarg"
end
