class CreateRooms < ActiveRecord::Migration
  def self.up
    create_table :rooms do |t|
      t.string :name
      t.string :description
      t.references :building
      t.string :number
      t.string :floor
      t.string :size
      t.timestamps
    end
  end
  
  def self.down
    drop_table :rooms
  end
end
