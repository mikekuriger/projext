class CreateVipsAssets < ActiveRecord::Migration
  def self.up
    create_table :vips_assets do |t|
      t.references :vip
      t.references :asset

      t.timestamps
    end
    add_index :vips_assets, [ :vip_id ]
    add_index :vips_assets, [ :asset_id ]
    add_index :vips_assets, [ :vip_id, :asset_id ], :unique => true
  end

  def self.down
    drop_table :vips_assets
  end
end
