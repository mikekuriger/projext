class AddFarmIdToStorageArrays < ActiveRecord::Migration
  def self.up
    add_column :storage_arrays, :farm_id, :integer

    add_index :storage_arrays, :farm_id
  end

  def self.down
    remove_column :storage_arrays, :farm_id
  end
end
