class AddStateToProjects < ActiveRecord::Migration
  def self.up
    add_column :projects, :state, :string, :default => 'active'
  end

  def self.down
    remove_column :projects, :state
  end
end
