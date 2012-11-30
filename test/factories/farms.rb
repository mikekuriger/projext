Factory.sequence :farm_name do |n|
  "MyFarm#{n}"
end

Factory.define :farm do |f|
  f.name                  { Factory.next :farm_name }
  f.description           { |farm| "#{farm.name} description" }
end
