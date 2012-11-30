class CreatePurchaseOrders < ActiveRecord::Migration
  def self.up
    create_table :purchase_orders do |t|
      t.string :name
      t.string :description
      t.date :created
      t.date :sent
      t.references :vendor
      t.string :number
      t.float :amount
      t.text :notes
      t.string :attachment_file_name
      t.string :attachment_content_type
      t.string :attachment_file_size
      t.string :attachment_updated_at
      t.timestamps
    end
  end
  
  def self.down
    drop_table :purchase_orders
  end
end
