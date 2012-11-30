Factory.sequence :vendor_name do |n|
  "MyVendor#{n}"
end

Factory.define :vendor do |f|
  f.name                  { Factory.next :vendor_name }
end
