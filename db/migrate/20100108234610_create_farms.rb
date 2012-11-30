class CreateFarms < ActiveRecord::Migration
  def self.up
    create_table :farms do |t|
      t.string :name
      t.string :description
      t.string :state, :default => 'active'
      t.timestamps
    end
    add_index :farms, :name, :unique => true
  end
  
  def self.down
    drop_table :farms
  end
end
