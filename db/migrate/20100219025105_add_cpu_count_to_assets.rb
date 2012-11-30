class AddCpuCountToAssets < ActiveRecord::Migration
  def self.up
    add_column :assets, :cpu_count, :integer
  end

  def self.down
    remove_column :assets, :cpu_count
  end
end
