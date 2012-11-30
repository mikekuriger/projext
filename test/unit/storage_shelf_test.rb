require 'test_helper'

class StorageShelfTest < ActiveSupport::TestCase
  should belong_to :storage_array
  should have_many :storage_heads, :through => :storage_array
  
  should allow_values_for :disk_type, "FC", "SATA", "SAS"
  should not_allow_values_for :disk_type, "foo", "baz", "blarg"
end
