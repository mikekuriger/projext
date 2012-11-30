class AssetsContract < ActiveRecord::Base
  belongs_to :asset
  belongs_to :contract

  # We don't want the same contract assigned twice to a single asset
  validates_uniqueness_of :contract_id, :scope => :asset_id, :message => "This contract has already been assigned to that asset"
  
  has_paper_trail
end
