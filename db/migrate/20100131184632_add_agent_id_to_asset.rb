class AddAgentIdToAsset < ActiveRecord::Migration
  def self.up
    add_column :assets, :agent_id, :integer
    add_index :assets, :agent_id
  end

  def self.down
    remove_index :assets, :agent_id
    remove_column :assets, :agent_id
  end
end
