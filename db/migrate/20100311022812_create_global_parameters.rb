class CreateGlobalParameters < ActiveRecord::Migration
  def self.up
    create_table :global_parameters do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :global_parameters
  end
end
