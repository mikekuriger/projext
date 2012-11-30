class CrontabsAsset < ActiveRecord::Base
  attr_accessible :crontab, :crontab_id

  belongs_to :crontab
  belongs_to :asset

  validates_uniqueness_of :asset_id, :scope => :crontab_id, :message => "That asset has already been assigned to this Crontab"
  
  has_paper_trail :meta => { :asset_id => Proc.new { |a| a.asset_id }}
end

