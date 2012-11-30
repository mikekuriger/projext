require 'test_helper'

class CustomerTest < ActiveSupport::TestCase
  should_have_many :projects
  should_have_many :apps, :through => :projects
  should_have_many :contacts_customers
  should_have_many :contacts, :through => :contacts_customers
  should_have_many :sites

  should_validate_presence_of :name
end

# == Schema Information
#
# Table name: customers
#
#  id            :integer(4)      not null, primary key
#  name          :string(255)
#  address1      :string(255)
#  address2      :string(255)
#  city          :string(255)
#  state         :string(255)
#  zip           :string(255)
#  url           :string(255)
#  contact1name  :string(255)
#  contact1phone :string(255)
#  contact1cell  :string(255)
#  contact1email :string(255)
#  contact2name  :string(255)
#  contact2phone :string(255)
#  contact2cell  :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#  notes         :string(255)
#

