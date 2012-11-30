require 'test_helper'

class LoadBalancerTest < ActiveSupport::TestCase
  should_have_many :vips
end
