class CreateOperatingsystems < ActiveRecord::Migration
  def self.up
    create_table :operatingsystems do |t|
      t.string :name
      t.string :description
      t.references :manufacturer
      t.string :ostype
      t.string :version
      t.string :architecture
      t.timestamps
    end
    add_index :operatingsystems, [ :manufacturer_id, :ostype, :version, :architecture ], :name => 'index_os_unique', :unique => true
  end
  
  def self.down
    drop_table :operatingsystems
  end
end
