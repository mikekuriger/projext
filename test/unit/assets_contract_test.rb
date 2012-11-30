require 'test_helper'

class AssetsContractTest < ActiveSupport::TestCase
  should belong_to :asset
  should belong_to :contract
  
  should validate_uniqueness_of :contract_id
end