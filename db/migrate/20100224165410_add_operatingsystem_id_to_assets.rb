class AddOperatingsystemIdToAssets < ActiveRecord::Migration
  def self.up
    add_column :assets, :operatingsystem_id, :integer
  end

  def self.down
    remove_column :assets, :operatingsystem_id
  end
end
