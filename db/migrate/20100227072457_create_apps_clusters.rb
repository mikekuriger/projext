class CreateAppsClusters < ActiveRecord::Migration
  def self.up
    create_table :apps_clusters do |t|
      t.references :app
      t.references :cluster

      t.timestamps
    end
    
    add_index :apps_clusters, [ :app_id ]
    add_index :apps_clusters, [ :cluster_id ]
    add_index :apps_clusters, [ :app_id, :cluster_id ], :unique => true
  end

  def self.down
    drop_table :apps_clusters
  end
end
