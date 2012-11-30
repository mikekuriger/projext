require 'test_helper'

class OperatingsystemTest < ActiveSupport::TestCase
  should belong_to :manufacturer
  should validate_presence_of :name, :message => "Operating system must have a name"
  should validate_presence_of :manufacturer_id, :message => "Operating system manufacturer can't be blank"
  should validate_presence_of :ostype, :message => "Operating system type can't be blank"

  # Also need to make sure that combination of manufacturer, ostype and version is unique
end
