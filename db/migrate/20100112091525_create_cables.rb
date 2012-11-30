class CreateCables < ActiveRecord::Migration
  def self.up
    create_table :cables do |t|
      t.references :interface
      t.integer :interface_id_target
      t.references :medium
      t.timestamps
    end
  end
  
  def self.down
    drop_table :cables
  end
end
