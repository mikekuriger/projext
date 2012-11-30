class CreateHardwareModels < ActiveRecord::Migration
  def self.up
    create_table :hardware_models do |t|
      t.string :name
      t.string :description
      t.references :manufacturer
      t.integer :rackunits
      t.timestamps
    end
  end
  
  def self.down
    drop_table :hardware_models
  end
end
