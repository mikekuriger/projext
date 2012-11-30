class AddTypeToAssets < ActiveRecord::Migration
  def self.up
    add_column :assets, :type, :string, :default => 'Asset'

    add_index :assets, :type
  end

  def self.down
    remove_column :assets, :type
  end
end
