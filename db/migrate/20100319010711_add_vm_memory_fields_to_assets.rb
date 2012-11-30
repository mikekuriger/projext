class AddVmMemoryFieldsToAssets < ActiveRecord::Migration
  def self.up
    add_column :assets, :vm_memory_target, :integer, :limit => 8
    add_column :assets, :vm_memory_dynamic_max, :integer, :limit => 8
    add_column :assets, :vm_memory_dynamic_min, :integer, :limit => 8
    add_column :assets, :vm_memory_static_min, :integer, :limit => 8
    add_column :assets, :vm_memory_static_max, :integer, :limit => 8
  end

  def self.down
    remove_column :assets, :vm_memory_static_max
    remove_column :assets, :vm_memory_static_min
    remove_column :assets, :vm_memory_dynamic_min
    remove_column :assets, :vm_memory_dynamic_max
    remove_column :assets, :vm_memory_target
  end
end
