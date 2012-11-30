class CreateStorageArrays < ActiveRecord::Migration
  def self.up
    create_table :storage_arrays do |t|
      t.string :name, :unique => true
      t.string :description
      t.timestamps
    end
  end
  
  def self.down
    drop_table :storage_arrays
  end
end
