require 'test_helper'

class AppsClusterTest < ActiveSupport::TestCase
  should belong_to :app
  should belong_to :cluster
end
