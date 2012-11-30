class CreateServices < ActiveRecord::Migration
  def self.up
    create_table :services do |t|
      t.references :cluster
      t.references :function
      t.string :state, :default => 'active'
      t.timestamps
    end
    add_index :services, :cluster_id
    add_index :services, :function_id
    add_index :services, [ :cluster_id, :function_id ], :unique => true
  end
  
  def self.down
    drop_table :services
  end
end
