class AddNotesToCircuits < ActiveRecord::Migration
  def self.up
    add_column :circuits, :notes, :text
  end

  def self.down
    remove_column :circuits, :notes
  end
end
