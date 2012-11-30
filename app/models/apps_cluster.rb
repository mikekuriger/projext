class AppsCluster < ActiveRecord::Base
  belongs_to :app
  belongs_to :cluster

  # We don't want the same cluster assigned twice to a single app
  validates_uniqueness_of :cluster_id, :scope => :app_id, :message => "That cluster has already been assigned to this app"
  
  has_paper_trail
end
