class CreateFunctions < ActiveRecord::Migration
  def self.up
    create_table :functions do |t|
      t.string :name
      t.string :description
      t.string :state, :default => 'active'
      t.timestamps
    end
    add_index :functions, :name, :unique => true
  end
  
  def self.down
    drop_table :functions
  end
end
