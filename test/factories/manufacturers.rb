Factory.sequence :manufacturer_name do |n|
  "manufacturer#{n}"
end

Factory.define :manufacturer do |f|
  f.name                  { Factory.next :manufacturer_name }
end
