class RenameParameterNameIdFieldInParameterAssignmentsTable < ActiveRecord::Migration
  def self.up
    rename_column :parameter_assignments, :parameter_name_id, :parameter_id
  end

  def self.down
    rename_column :parameter_assignments, :parameter_id, :parameter_name_id
  end
end
