class CreateEmailsAliases < ActiveRecord::Migration
  def self.up
    create_table :emails_aliases do |t|
      t.references :email
      t.references :alias

      t.timestamps
    end
  end

  def self.down
    drop_table :emails_aliases
  end
end
