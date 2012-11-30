class AddKernelReleaseToAssets < ActiveRecord::Migration
  def self.up
    add_column :assets, :kernel_release, :string
  end

  def self.down
    remove_column :assets, :kernel_release
  end
end
