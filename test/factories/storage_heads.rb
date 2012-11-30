Factory.sequence :storage_head_name do |n|
  "MyStorageHead#{n}"
end

Factory.sequence :storage_head_serial do |n|
  "storagehead#{n}"
end

Factory.define :storage_head do |storage_head|
  storage_head.name                  { Factory.next :storage_head_name }
  storage_head.description           { "Storage head description" }
  storage_head.serial                { Factory.next :storage_head_serial }
end

Factory.define :storage_head_with_interface, :parent => :storage_head do |storage_head|
  storage_head.association           :interface, :factory => :interface
end
