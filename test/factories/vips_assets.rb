Factory.define :vips_asset do |vips_asset|
  vips_asset.association           :vip, :factory => :vip
  vips_asset.association           :asset, :factory => :asset
end
