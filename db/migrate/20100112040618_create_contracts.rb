class CreateContracts < ActiveRecord::Migration
  def self.up
    create_table :contracts do |t|
      t.string :name
      t.string :type, :default => 'Contract'
      t.string :description
      t.string :number
      t.string :supportlevel
      t.references :vendor
      t.date :start
      t.date :end
      t.references :quote
      t.references :purchaseorder
      t.text :notes
      t.timestamps
    end
  end
  
  def self.down
    drop_table :contracts
  end
end
