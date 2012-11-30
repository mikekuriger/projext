class AddLastSeenToAssets < ActiveRecord::Migration
  def self.up
    add_column :assets, :last_seen, :datetime
  end

  def self.down
    remove_column :assets, :last_seen
  end
end
