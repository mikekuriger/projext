class CreateParameterNames < ActiveRecord::Migration
  def self.up
    create_table :parameter_names do |t|
      t.string :name
      t.string :description
      t.string :state, :default => 'active'
      t.timestamps
    end
    add_index :parameter_names, :name, :unique => true
  end
  
  def self.down
    drop_table :parameter_names
  end
end
