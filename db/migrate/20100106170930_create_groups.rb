class CreateGroups < ActiveRecord::Migration
  def self.up
    create_table :groups do |t|
      t.string :name
      t.string :description
      t.string :state, :default => 'active'
      t.timestamps
    end
    add_index :groups, :name, :unique => true
  end
  
  def self.down
    drop_table :groups
  end
end
