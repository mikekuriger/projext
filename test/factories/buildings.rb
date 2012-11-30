Factory.sequence :building_name do |n|
  "building#{n}"
end

Factory.define :building do |f|
  f.name                  { Factory.next :building_name }
  f.description           { |building| "#{building.name} description" }
end
