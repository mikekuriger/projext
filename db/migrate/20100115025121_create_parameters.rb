class CreateParameters < ActiveRecord::Migration
  def self.up
    create_table :parameters do |t|
      t.references :assignable, :polymorphic => true
      t.string :assignable_type
      t.references :parameter_name
      t.string :value
      t.timestamps
    end
    add_index :parameters, [ :assignable_id, :assignable_type, :parameter_name_id ], { :unique => true, :name => :parameter_name_index }
  end
  
  def self.down
    drop_table :parameters
  end
end
