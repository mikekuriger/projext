class AddTypeToParameters < ActiveRecord::Migration
  def self.up
    add_column :parameters, :type, :string, :default => 'Parameter'

    add_index :parameters, :type
  end

  def self.down
    remove_column :parameters, :type
  end
end
