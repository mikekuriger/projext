Factory.define :assets_contract do |assets_contract|
  assets_contract.association           :asset, :factory => :asset
  assets_contract.association           :contract, :factory => :contract
end
