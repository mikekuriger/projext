require 'test_helper'

class ContactsCustomerTest < ActiveSupport::TestCase
  should_belong_to :contact
  should_belong_to :customer
  
  should_validate_uniqueness_of :contact_id, :scoped_to => :customer_id, :message => "That contact has already been assigned to this customer"
end
