class AddAssetIdToVersions < ActiveRecord::Migration
  def self.up
    add_column :versions, :asset_id, :integer
    add_index :versions, :asset_id
  end

  def self.down
    remove_index :versions, :asset_id
    remove_column :versions, :asset_id
  end
end
