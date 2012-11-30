require 'test_helper'

class PortTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Port.new.valid?
  end
end
