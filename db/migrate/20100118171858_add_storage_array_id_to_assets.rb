class AddStorageArrayIdToAssets < ActiveRecord::Migration
  def self.up
    add_column :assets, :storage_array_id, :integer
  end

  def self.down
    remove_column :assets, :storage_array_id
  end
end
