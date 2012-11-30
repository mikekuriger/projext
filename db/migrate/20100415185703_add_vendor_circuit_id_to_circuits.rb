class AddVendorCircuitIdToCircuits < ActiveRecord::Migration
  def self.up
    add_column :circuits, :vendor_circuit_id, :string
  end

  def self.down
    remove_column :circuits, :vendor_circuit_id
  end
end
