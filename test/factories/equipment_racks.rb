Factory.sequence :equipment_rack_name do |n|
  "MyRack#{n}"
end

Factory.define :equipment_rack do |f|
  f.name                  { Factory.next :equipment_rack_name }
  f.description           { |equipment_rack| "#{equipment_rack.name} description" }
end
