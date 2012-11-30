class CreateCpus < ActiveRecord::Migration
  def self.up
    create_table :cpus do |t|
      t.references :manufacturer
      t.string :cpu_type
      t.integer :cores, :default => 1
      t.string :speed
      t.timestamps
    end
    add_index :cpus, [ :manufacturer_id, :cpu_type, :cores, :speed ], :unique => true, :name => 'cpu_index'
  end
  
  def self.down
    drop_table :cpus
  end
end
