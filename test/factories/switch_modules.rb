Factory.sequence :switch_module_name do |n|
  "switch_module#{n}"
end

Factory.define :switch_module do |f|
  f.name                  { Factory.next :switch_module_name }
  f.description           { |switch_module| "#{switch_module.name} description" }
end

