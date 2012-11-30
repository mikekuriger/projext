class AddContactFieldsToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :title, :string
    add_column :users, :phone, :string
    add_column :users, :cell, :string
    add_column :users, :pager, :string
  end

  def self.down
    remove_column :users, :pager
    remove_column :users, :cell
    remove_column :users, :phone
    remove_column :users, :title
  end
end
