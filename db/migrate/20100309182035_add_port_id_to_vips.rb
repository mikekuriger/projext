class AddPortIdToVips < ActiveRecord::Migration
  def self.up
    add_column :vips, :port_id, :integer, :index => true
  end

  def self.down
    remove_column :vips, :port_id
  end
end
