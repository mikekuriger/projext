require 'test_helper'

class ContactTest < ActiveSupport::TestCase
  should_have_many :contacts_customers
  should_have_many :customers, :through => :contacts_customers
  
  should_validate_presence_of :first_name, :message => "First name cannot be blank"
  should_validate_presence_of :last_name, :message => "Last name cannot be blank"
end
