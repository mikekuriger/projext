require 'test_helper'

class BuildingTest < ActiveSupport::TestCase
  should_have_many :rooms
  
  should_validate_presence_of :name, :message => "Building name can't be blank"
  should_validate_uniqueness_of :name, :message => "Building name must be unique"
  
  context 'A building' do
    setup do
      @building = Factory(:building)
    end

    should 'be valid' do
      assert @building.valid?
    end
  end
end

# == Schema Information
#
# Table name: buildings
#
#  id          :integer(4)      not null, primary key
#  name        :string(255)
#  description :string(255)
#  address1    :string(255)
#  address2    :string(255)
#  city        :string(255)
#  state       :string(255)
#  zip         :string(255)
#  country     :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

