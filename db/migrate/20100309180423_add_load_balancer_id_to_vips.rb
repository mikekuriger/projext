class AddLoadBalancerIdToVips < ActiveRecord::Migration
  def self.up
    add_column :vips, :load_balancer_id, :integer, :index => true
  end

  def self.down
    remove_column :vips, :load_balancer_id
  end
end
