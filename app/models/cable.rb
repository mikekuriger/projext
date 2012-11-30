class Cable < ActiveRecord::Base
  # Can't use :target because it is already in use by cancan
  attr_accessible :interface, :interface_id, :interface_target, :interface_id_target, :medium, :medium_id, :notes

  # For cascading selects in the form
  attr_accessible :device, :target_device
  attr_accessor :device, :target_device
  
  belongs_to :interface
  belongs_to :interface_target, :class_name => 'Interface', :foreign_key => :interface_id_target

  belongs_to :medium
  
  validates_presence_of :interface, :message => "Source interface must exist"
  validates_presence_of :interface_target, :message => "Target interface must exist"
  
  validates_uniqueness_of :interface, :message => "Source interface already has a connection"
  validates_uniqueness_of :interface_target, :message => "Target interface already has a connection"
end

# == Schema Information
#
# Table name: cables
#
#  id                :integer(4)      not null, primary key
#  from_interface_id :integer(4)
#  to_interface_id   :integer(4)
#  medium_id         :integer(4)
#  created_at        :datetime
#  updated_at        :datetime
#

