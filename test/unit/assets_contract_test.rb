require 'test_helper'

class AssetsContractTest < ActiveSupport::TestCase
  should_belong_to :asset
  should_belong_to :contract
  
  should_validate_uniqueness_of :contract_id, :scoped_to => :asset_id, :message => "This contract has already been assigned to that asset"
end