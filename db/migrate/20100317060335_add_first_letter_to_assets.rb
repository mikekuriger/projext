class AddFirstLetterToAssets < ActiveRecord::Migration
  def self.up
    add_column :assets, :first_letter, :string

    add_index :assets, :first_letter
  end

  def self.down
    remove_column :assets, :first_letter
  end
end
