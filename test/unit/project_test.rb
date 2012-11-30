require 'test_helper'

class ProjectTest < ActiveSupport::TestCase
  should belong_to :customer
  
  should have_many :apps

  should validate_presence_of :name, :message => "Project name cannot be blank"
  should validate_presence_of :customer_id, :message => "Customer cannot be blank"
end
