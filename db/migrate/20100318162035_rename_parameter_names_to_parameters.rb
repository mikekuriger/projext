class RenameParameterNamesToParameters < ActiveRecord::Migration
  def self.up
    rename_table :parameter_names, :parameters
  end

  def self.down
    rename_table :parameters, :parameter_names
  end
end
