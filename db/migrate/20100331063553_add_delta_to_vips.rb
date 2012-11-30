class AddDeltaToVips < ActiveRecord::Migration
  def self.up
    add_column :vips, :delta, :boolean, :default => true, :null => false
  end

  def self.down
    remove_column :vips, :delta
  end
end
