class AddVmPowerStateToAssets < ActiveRecord::Migration
  def self.up
    add_column :assets, :vm_power_state, :string
  end

  def self.down
    remove_column :assets, :vm_power_state
  end
end
