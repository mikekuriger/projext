require 'test_helper'

class CircuitTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Circuit.new.valid?
  end
end
