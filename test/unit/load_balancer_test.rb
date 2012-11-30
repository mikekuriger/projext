require 'test_helper'

class LoadBalancerTest < ActiveSupport::TestCase
  should have_many :vips
end
