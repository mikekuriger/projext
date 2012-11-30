class DropStorageArrays < ActiveRecord::Migration
  def self.up
    drop_table :storage_arrays
  end

  def self.down
  end
end
