require 'test_helper'

class StorageHeadTest < ActiveSupport::TestCase
  should belong_to :storage_array
  should have_many :storage_shelves, :through => :storage_array
end
