class CreateIps < ActiveRecord::Migration
  def self.up
    create_table :ips do |t|
      t.references :network
      t.string :ip
      t.boolean :pingable
      t.datetime :lastpinged
      t.datetime :lastresponse
      t.text :notes
      t.timestamps
    end
    add_index :ips, :ip, :unique => true
  end
  
  def self.down
    drop_table :ips
  end
end
