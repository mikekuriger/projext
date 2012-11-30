class EquipmentRack < ActiveRecord::Base
  attr_accessible :room, :room_id, :name, :description, :state, :units
  
  # By default, we want records ordered by name, ascending
  default_scope :order => 'name ASC'
  
  belongs_to :room
  has_many :assets
  has_many :servers
  
  validates_presence_of :name, :message => "Rack name can't be blank"
  
  has_paper_trail
  
  state_machine :initial => :active do
    event :deactivate do
      transition :active => :inactive
    end
    
    event :activate do
      transition :inactive => :active
    end
    
    state :active do
    end
    
    state :inactive do
    end
  end

  # Return the asset that is occupying a specific rack unit
  def asset_at_unit(unit)
    retval = nil
    assets.each do |asset|
      if asset.rack_unit_range
        retval = asset if asset.rack_unit_range.include? unit
      end
    end
    return retval
  end
end

# == Schema Information
#
# Table name: equipment_racks
#
#  id          :integer(4)      not null, primary key
#  room_id     :integer(4)
#  name        :string(255)
#  description :string(255)
#  state       :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

