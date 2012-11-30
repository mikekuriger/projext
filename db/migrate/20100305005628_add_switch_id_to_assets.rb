class AddSwitchIdToAssets < ActiveRecord::Migration
  def self.up
    add_column :assets, :switch_id, :integer
  end

  def self.down
    remove_column :assets, :switch_id
  end
end
