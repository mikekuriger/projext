class CreateInterfaces < ActiveRecord::Migration
  def self.up
    create_table :interfaces do |t|
      t.string :name
      t.string :description
      t.string :state
      t.references :asset
      t.references :ip
      t.string :speed
      t.string :mac, :default => '00:00:00:00:00:00'
      t.references :connector
      t.timestamps
    end
  end
  
  def self.down
    drop_table :interfaces
  end
end
