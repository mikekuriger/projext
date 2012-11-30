class AddDiskInfoToAssets < ActiveRecord::Migration
  def self.up
    add_column :assets, :disk_size, :integer
    add_column :assets, :disk_type, :string
    add_column :assets, :disk_count, :integer
  end

  def self.down
    remove_column :assets, :disk_count
    remove_column :assets, :disk_type
    remove_column :assets, :disk_size
  end
end
