class CreateCircuits < ActiveRecord::Migration
  def self.up
    create_table :circuits do |t|
      t.string :name
      t.string :description
      t.integer :vendor_id
      t.timestamps
    end
  end
  
  def self.down
    drop_table :circuits
  end
end
