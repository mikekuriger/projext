require 'test_helper'

class StorageHeadTest < ActiveSupport::TestCase
  should_belong_to :storage_array
  should_have_many :storage_shelves, :through => :storage_array
end
