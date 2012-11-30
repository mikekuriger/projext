class CreateCrontabs < ActiveRecord::Migration
  def self.up
    create_table :crontabs do |t|
        t.references :cluster
        t.string :name
        t.string :description
        t.string :minute, :limit=>32, :default => '*'
        t.string :hour, :limit=>32, :default => '*'
        t.string :dayofmonth, :limit=>32, :default => '*'
        t.string :month, :limit=>32, :default => '*'
        t.string :dayofweek, :limit=>32, :default => '*'
        t.string :user, :limit=>64
        t.string :command, :limit=>1024
        
        t.timestamps
    end
  end

  def self.down
    drop_table :crontabs
  end
end
