class AddOobToAssets < ActiveRecord::Migration
  def self.up
    add_column :assets, :oob, :string
  end

  def self.down
    remove_column :assets, :oob
  end
end
