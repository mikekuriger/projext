class Crontab < ActiveRecord::Base
  attr_accessible :name, :description, :cluster_id, :minute, :hour, :dayofweek, :month, :dayofmonth, :user, :command, :asset_ids

  # By default, we want records ordered by name, ascending
  default_scope :order => 'name ASC'

  belongs_to :cluster

  has_many :crontabs_assets
  has_many :assets, :through => :crontabs_assets

  validates_presence_of :name, :message => "Crontab name cannot be blank"
  validates_presence_of :cluster_id, :message => "Cluster cannot be blank"

  has_paper_trail
  
end
