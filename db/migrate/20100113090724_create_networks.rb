class CreateNetworks < ActiveRecord::Migration
  def self.up
    create_table :networks do |t|
      t.references :farm
      t.string :network
      t.integer :subnetbits
      t.string :gateway
      t.string :vlan
      t.string :description
      t.text :notes
      t.timestamps
    end
  end
  
  def self.down
    drop_table :networks
  end
end
