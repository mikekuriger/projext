class CreateServiceAssignments < ActiveRecord::Migration
  def self.up
    create_table :service_assignments do |t|
      t.references :asset
      t.references :service

      t.timestamps
    end
    add_index :service_assignments, [ :asset_id ]
    add_index :service_assignments, [ :service_id ]
    add_index :service_assignments, [ :asset_id, :service_id ], :unique => true
  end

  def self.down
    drop_table :service_assignments
  end
end
