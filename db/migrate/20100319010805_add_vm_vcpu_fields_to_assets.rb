class AddVmVcpuFieldsToAssets < ActiveRecord::Migration
  def self.up
    add_column :assets, :vm_vcpus_max, :integer
    add_column :assets, :vm_vcpus_at_startup, :integer
  end

  def self.down
    remove_column :assets, :vm_vcpus_at_startup
    remove_column :assets, :vm_vcpus_max
  end
end
