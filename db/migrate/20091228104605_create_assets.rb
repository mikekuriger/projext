class CreateAssets < ActiveRecord::Migration
  def self.up
    create_table :assets do |t|
      t.string :name
      t.string :hostname
      t.string :domain
      t.string :description
      t.string :serial
      t.string :wb_asset_id
      t.references :hardware_model
      t.references :group
      t.references :farm
      t.references :equipment_rack
      t.integer :rack_elevation
      t.integer :rack_units
      t.date :purchase_date
      t.references :vendor
      t.boolean :leased
      t.string :sap_asset_id
      t.string :sap_wbs_element
      t.boolean :monitorable
      t.string :state, :default => 'new'
      t.timestamps
    end
    
    add_index :assets, [:name]
    add_index :assets, [ :hostname, :domain ], :unique
  end
  
  def self.down
    drop_table :assets
  end
end
