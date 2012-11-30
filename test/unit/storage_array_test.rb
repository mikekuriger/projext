require 'test_helper'

class StorageArrayTest < ActiveSupport::TestCase
  subject { Factory(:storage_array) }
  should have_many :storage_heads, :storage_shelves
  should belong_to :farm
  
  should validate_presence_of :name, :message => "Storage array name must exist"
  should validate_uniqueness_of :name, :message => "Storage array name must be unique"
end
