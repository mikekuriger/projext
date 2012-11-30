class AddDeltaToAssets < ActiveRecord::Migration
  def self.up
    add_column :assets, :delta, :boolean, :default => true
  end

  def self.down
    remove_column :assets, :delta
  end
end
