class CreateManufacturers < ActiveRecord::Migration
  def self.up
    create_table :manufacturers do |t|
      t.string :name
      t.string :address1
      t.string :address2
      t.string :city
      t.string :state
      t.string :zip
      t.string :url
      t.text :notes
      t.timestamps
    end
    add_index :manufacturers, :name, :unique => true
  end
  
  def self.down
    drop_table :manufacturers
  end
end
