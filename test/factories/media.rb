Factory.sequence :medium_name do |n|
  "medium#{n}"
end

Factory.define :medium do |f|
  f.name                  { Factory.next :medium_name }
  f.description           { |medium| "#{medium.name} description" }
end
