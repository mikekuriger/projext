require 'test_helper'

class RoomTest < ActiveSupport::TestCase
  should belong_to :building
  should have_many :equipment_racks
  
  context 'A room' do
    setup do
      @room = Factory(:room)
    end

    should 'be valid' do
      assert @room.valid?
    end
  end
end

# == Schema Information
#
# Table name: rooms
#
#  id          :integer(4)      not null, primary key
#  name        :string(255)
#  description :string(255)
#  building_id :integer(4)
#  number      :string(255)
#  floor       :string(255)
#  size        :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

