class CreateSites < ActiveRecord::Migration
  def self.up
    create_table :sites do |t|
      t.string :name
      t.references :ip
      t.references :vip
      t.references :cluster
      t.references :customer
      t.string :state, :default => 'active'
      t.timestamps
    end
  end
  
  def self.down
    drop_table :sites
  end
end
