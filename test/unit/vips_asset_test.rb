require 'test_helper'

class VipsAssetTest < ActiveSupport::TestCase
  should_belong_to :vip, :asset
  
  should_validate_uniqueness_of :asset_id, :scoped_to => :vip_id, :message => "That asset has already been assigned to this VIP"
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

