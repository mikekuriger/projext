class ReplaceConnectorIdWithConnectorTypeInInterfaces < ActiveRecord::Migration
  def self.up
    remove_column :interfaces, :connector_id
    add_column :interfaces, :connector_type, :string
  end

  def self.down
    add_column :interfaces, :connector_id, :integer
    remove_column :interfaces, :connector_type
  end
end
