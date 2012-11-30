require 'test_helper'

class VendorTest < ActiveSupport::TestCase
  should have_many :contracts
  
  should validate_presence_of :name, :message => "Vendor name can't be blank"
  
  context 'A vendor' do
    setup do
      @vendor = Factory(:vendor)
    end

    should 'be valid' do
      assert @vendor.valid?
    end
  end
end

# == Schema Information
#
# Table name: vendors
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  address1   :string(255)
#  address2   :string(255)
#  city       :string(255)
#  state      :string(255)
#  zip        :string(255)
#  country    :string(255)
#  url        :string(255)
#  notes      :text
#  created_at :datetime
#  updated_at :datetime
#

