class Room < ActiveRecord::Base
  attr_accessible :name, :description, :building, :building_id, :number, :floor, :size
  
  belongs_to :building
  has_many :equipment_racks
  
  # By default, we want records ordered by name, ascending
  default_scope :order => 'name ASC'
  
  validates_presence_of :name, :message => "Room name can't be blank"
  validates_uniqueness_of :name, :message => "Room name must be unique"
  
  has_paper_trail
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

