class AddStateToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :state, :string, :default => 'new'
  end

  def self.down
    remove_column :users, :state
  end
end
