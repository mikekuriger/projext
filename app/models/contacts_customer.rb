class ContactsCustomer < ActiveRecord::Base
  belongs_to :contact
  belongs_to :customer

  # We don't want the same contact assigned twice to a single customer
  validates_uniqueness_of :contact_id, :scope => :customer_id, :message => "That contact has already been assigned to this customer"
  
  has_paper_trail
end
