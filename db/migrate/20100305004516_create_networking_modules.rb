class CreateNetworkingModules < ActiveRecord::Migration
  def self.up
    create_table :networking_modules do |t|
      t.string :name
      t.string :description
      t.string :serial
      t.integer :hardware_model_id
      t.timestamps
    end
  end
  
  def self.down
    drop_table :networking_modules
  end
end
