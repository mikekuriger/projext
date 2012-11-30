class AddLocationFieldsToAssets < ActiveRecord::Migration
  def self.up
    add_column :assets, :building_id, :integer
    add_column :assets, :room_id, :integer
  end

  def self.down
    remove_column :assets, :room_id
    remove_column :assets, :building_id
  end
end
