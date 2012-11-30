Factory.sequence :storage_shelf_name do |n|
  "MyStorageShelf#{n}"
end

Factory.sequence :storage_shelf_serial do |n|
  "serial#{n}"
end

Factory.define :storage_shelf do |storage_shelf|
  storage_shelf.name                  { Factory.next :storage_shelf_name }
  storage_shelf.description           { "Storage shelf description" }
  storage_shelf.serial                { Factory.next :storage_shelf_serial }
  storage_shelf.disk_size             { 1024 }
  storage_shelf.disk_type             { "SATA" }
  storage_shelf.disk_count            { 14 }
end

Factory.define :storage_shelf_with_interface, :parent => :storage_shelf do |storage_shelf|
  storage_shelf.association           :interface, :factory => :interface
end