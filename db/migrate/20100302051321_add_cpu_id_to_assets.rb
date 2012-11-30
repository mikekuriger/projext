class AddCpuIdToAssets < ActiveRecord::Migration
  def self.up
    add_column :assets, :cpu_id, :integer
  end

  def self.down
    remove_column :assets, :cpu_id
  end
end
