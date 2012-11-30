class AddIndexesToAssets < ActiveRecord::Migration
  def self.up
    add_index :assets, :group_id
    add_index :assets, :farm_id
    add_index :assets, :equipment_rack_id
    add_index :assets, :hardware_model_id
    add_index :assets, :parent_id
    add_index :assets, :switch_id
  end

  def self.down
    remove_index :assets, :group_id
    remove_index :assets, :farm_id
    remove_index :assets, :equipment_rack_id
    remove_index :assets, :hardware_model_id
    remove_index :assets, :parent_id
    remove_index :assets, :switch_id
  end
end
