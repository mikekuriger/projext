require 'test_helper'

class AppsClusterTest < ActiveSupport::TestCase
  should_belong_to :app
  should_belong_to :cluster
end
