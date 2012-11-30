class RemoveBuildingAndRoomFromAssets < ActiveRecord::Migration
  def self.up
    remove_column :assets, :building_id
    remove_column :assets, :room_id
  end

  def self.down
    add_column :assets, :building_id, :integer
    add_column :assets, :room_id, :integer
    
    add_index :assets, :building_id
    add_index :assets, :room_id
  end
end
