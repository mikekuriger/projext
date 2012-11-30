Factory.sequence :parameter_name do |n|
  "parameter#{n}"
end

Factory.define :parameter do |f|
  f.name                  { Factory.next :parameter_name }
  f.description           { |parameter| "#{parameter.name} description" }
end

