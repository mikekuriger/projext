class AddLocalNameToInterfaces < ActiveRecord::Migration
  def self.up
    add_column :interfaces, :local_name, :string
  end

  def self.down
    remove_column :interfaces, :local_name
  end
end
