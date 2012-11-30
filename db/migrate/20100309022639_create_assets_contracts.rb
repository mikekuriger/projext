class CreateAssetsContracts < ActiveRecord::Migration
  def self.up
    create_table :assets_contracts do |t|
      t.references :asset
      t.references :contract
      t.timestamps
    end
    
    add_index :assets_contracts, :asset_id
    add_index :assets_contracts, :contract_id
    add_index :assets_contracts, [ :asset_id, :contract_id ], :unique => true, :name => 'asset_contract_index'
  end

  def self.down
    drop_table :assets_contracts
  end
end
