Factory.sequence :group_name do |n|
  "MyGroup#{n}"
end

Factory.define :group do |group|
  group.name                  { Factory.next :group_name }
  group.description           { |a| "#{a.name} description" }
end
