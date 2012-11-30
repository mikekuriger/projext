class CreateEquipmentRacks < ActiveRecord::Migration
  def self.up
    create_table :equipment_racks do |t|
      t.references :room
      t.string :name
      t.string :description
      t.string :state
      t.timestamps
    end
  end
  
  def self.down
    drop_table :equipment_racks
  end
end
