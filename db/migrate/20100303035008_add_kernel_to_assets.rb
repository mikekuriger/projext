class AddKernelToAssets < ActiveRecord::Migration
  def self.up
    add_column :assets, :kernel, :string
  end

  def self.down
    remove_column :assets, :kernel
  end
end
