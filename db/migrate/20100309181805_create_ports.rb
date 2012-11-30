class CreatePorts < ActiveRecord::Migration
  def self.up
    create_table :ports do |t|
      t.string :name
      t.string :description
      t.string :protocol
      t.integer :begin_port
      t.integer :end_port
      t.timestamps
    end
  end
  
  def self.down
    drop_table :ports
  end
end
