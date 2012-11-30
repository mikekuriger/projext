class AddVirtualizationHostToAssets < ActiveRecord::Migration
  def self.up
    add_column :assets, :virtualization_host, :boolean, :default => false
  end

  def self.down
    remove_column :assets, :virtualization_host
  end
end
