class AddNotesToAssets < ActiveRecord::Migration
  def self.up
    add_column :assets, :notes, :text
  end

  def self.down
    remove_column :assets, :notes
  end
end
