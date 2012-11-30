class AddNotesToCables < ActiveRecord::Migration
  def self.up
    add_column :cables, :notes, :text
  end

  def self.down
    remove_column :cables, :notes
  end
end
