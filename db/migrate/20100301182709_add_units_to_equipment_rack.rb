class AddUnitsToEquipmentRack < ActiveRecord::Migration
  def self.up
    add_column :equipment_racks, :units, :integer, :default => 42
  end

  def self.down
    remove_column :equipment_racks, :units
  end
end
