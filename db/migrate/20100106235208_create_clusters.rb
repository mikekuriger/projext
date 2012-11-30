class CreateClusters < ActiveRecord::Migration
  def self.up
    create_table :clusters do |t|
      t.string :name
      t.string :description
      t.string :state, :default => 'active'
      t.timestamps
    end
    add_index :clusters, :name, :unique => true
  end
  
  def self.down
    drop_table :clusters
  end
end
