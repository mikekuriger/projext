class AddModularToAssets < ActiveRecord::Migration
  def self.up
    add_column :assets, :modular, :boolean
  end

  def self.down
    remove_column :assets, :modular
  end
end
