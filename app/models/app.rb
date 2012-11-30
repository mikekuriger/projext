class App < ActiveRecord::Base
  attr_accessible :name, :description, :project, :project_id, :cluster_ids

  belongs_to :project
  has_many :apps_clusters
  has_many :clusters, :through => :apps_clusters
  has_many :sites, :through => :clusters

  validates_presence_of :name, :message => "Name cannot be blank"
  validates_presence_of :project_id, :message => "Project cannot be blank" 
  
  has_paper_trail
end
