Factory.sequence :asset_name do |n|
  "MyAsset#{n}"
end

Factory.sequence :asset_serial do |n|
  "serial#{n}"
end

Factory.define :asset do |asset|
  asset.name                  { Factory.next :asset_name }
  asset.description           { "Asset description" }
  asset.serial                { Factory.next :asset_serial }
end

Factory.define :asset_with_interface, :parent => :asset do |asset|
  asset.association           :interface, :factory => :interface
end