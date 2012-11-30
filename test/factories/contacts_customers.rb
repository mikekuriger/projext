Factory.define :contacts_customer do |contacts_customer|
  contacts_customer.association           :contact, :factory => :contact
  contacts_customer.association           :customer, :factory => :customer
end
