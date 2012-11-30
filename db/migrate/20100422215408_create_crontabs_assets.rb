class CreateCrontabsAssets < ActiveRecord::Migration
  def self.up
    create_table :crontabs_assets do |t|
      t.references :crontab
      t.references :asset

      t.timestamps
    end
    add_index :crontabs_assets, [ :crontab_id ]
    add_index :crontabs_assets, [ :asset_id ]
    add_index :crontabs_assets, [ :crontab_id, :asset_id ], :unique => true
  end

  def self.down
      drop_table :crontabs_assets
  end
end
