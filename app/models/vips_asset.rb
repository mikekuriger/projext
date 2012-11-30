class VipsAsset < ActiveRecord::Base
  belongs_to :vip
  belongs_to :asset

  # We don't want the same service assigned twice to a single asset
  validates_uniqueness_of :asset_id, :scope => :vip_id, :message => "That asset has already been assigned to this VIP"
  
  has_paper_trail :meta => { :asset_id => Proc.new { |a| a.asset_id }}
end

# == Schema Information
#
# Table name: vips_assets
#
#  id         :integer(4)      not null, primary key
#  vip_id     :integer(4)
#  asset_id   :integer(4)
#  created_at :datetime
#  updated_at :datetime
#

