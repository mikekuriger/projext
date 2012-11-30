class CreateEmails < ActiveRecord::Migration
  def self.up
    create_table :emails do |t|
      t.string :name
      t.references :domain
      t.references :project
      t.timestamps
    end
  end
  
  def self.down
    drop_table :emails
  end
end
