class CreateAppsContacts < ActiveRecord::Migration
  def self.up
    create_table :apps_contacts do |t|
      t.references :app
      t.references :contact
      t.timestamps
    end
    add_index :apps_contacts, [ :app_id ]
    add_index :apps_contacts, [ :contact_id ]
    add_index :apps_contacts, [ :app_id, :contact_id ], :unique => true
  end

  def self.down
    drop_table :apps_contacts
  end
end
