class CreateContactsCustomers < ActiveRecord::Migration
  def self.up
    create_table :contacts_customers do |t|
      t.references :contact
      t.references :customer
      
      t.timestamps
    end
    
    add_index :contacts_customers, [ :contact_id ]
    add_index :contacts_customers, [ :customer_id ]
    add_index :contacts_customers, [ :contact_id, :customer_id ], :unique => true
  end

  def self.down
    drop_table :contacts_customers
  end
end
