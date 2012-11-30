require 'test_helper'

class SoftwareLicenseTest < ActiveSupport::TestCase
  should_validate_presence_of :name, :message => "Asset name can't be blank"
end
