require 'test_helper'

class ProjectTest < ActiveSupport::TestCase
  should_belong_to :customer
  
  should_have_many :apps

  should_validate_presence_of :name, :message => "Project name cannot be blank"
  should_validate_presence_of :customer_id, :message => "Customer cannot be blank"
end
