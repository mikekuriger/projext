class RenameParametersToParameterAssignments < ActiveRecord::Migration
  def self.up
    rename_table :parameters, :parameter_assignments
  end

  def self.down
    rename_table :parameter_assignments, :parameters
  end
end
