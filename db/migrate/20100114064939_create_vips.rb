class CreateVips < ActiveRecord::Migration
  def self.up
    create_table :vips do |t|
      t.string :name
      t.string :description
      t.references :ip
      t.text :notes
      t.string :state, :default => 'active'
      t.timestamps
    end
  end
  
  def self.down
    drop_table :vips
  end
end
