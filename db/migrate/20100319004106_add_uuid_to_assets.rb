class AddUuidToAssets < ActiveRecord::Migration
  def self.up
    add_column :assets, :uuid, :string

    add_index :assets, :uuid, :unique => true
  end

  def self.down
    remove_column :assets, :uuid
  end
end
