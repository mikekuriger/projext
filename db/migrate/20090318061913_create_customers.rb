class CreateCustomers < ActiveRecord::Migration
  def self.up
    create_table :customers do |t|
      t.string :name
      t.string :address1
      t.string :address2
      t.string :city
      t.string :state
      t.string :zip
      t.string :url
      t.string :notes
      
      t.timestamps
    end
  end

  def self.down
    drop_table :customers
  end
end
