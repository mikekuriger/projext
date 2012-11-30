require 'test_helper'

class StorageArrayTest < ActiveSupport::TestCase
  subject { Factory(:storage_array) }
  should_have_many :storage_heads, :storage_shelves
  should_belong_to :farm
  
  should_validate_presence_of :name, :message => "Storage array name must exist"
  should_validate_uniqueness_of :name, :message => "Storage array name must be unique"
end
