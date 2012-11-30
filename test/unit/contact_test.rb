require 'test_helper'

class ContactTest < ActiveSupport::TestCase
  should have_many :contacts_customers
  should have_many :customers
  
  should validate_presence_of :first_name
  should validate_presence_of :last_name
end
