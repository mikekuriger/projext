require 'test_helper'

class ContactsCustomerTest < ActiveSupport::TestCase
  should belong_to :contact
  should belong_to :customer
  
  should validate_uniqueness_of :contact_id
end
