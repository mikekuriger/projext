class AddPhysicalMemoryToAssets < ActiveRecord::Migration
  def self.up
    add_column :assets, :physical_memory, :string
  end

  def self.down
    remove_column :assets, :physical_memory
  end
end
