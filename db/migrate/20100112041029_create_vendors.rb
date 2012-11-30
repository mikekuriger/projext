class CreateVendors < ActiveRecord::Migration
  def self.up
    create_table :vendors do |t|
      t.string :name
      t.string :address1
      t.string :address2
      t.string :city
      t.string :state
      t.string :zip
      t.string :country
      t.string :url
      t.text :notes
      t.timestamps
    end
  end
  
  def self.down
    drop_table :vendors
  end
end
