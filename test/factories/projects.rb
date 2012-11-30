Factory.sequence :project_name do |n|
  "project#{n}"
end

Factory.define :project do |f|
  f.name                  { Factory.next :project_name }
  f.description           { |project| "#{project.name} description" }
  f.association           :customer, :factory => :customer
end

