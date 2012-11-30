Factory.sequence :storage_array_name do |n|
  "storage_array#{n}"
end

Factory.define :storage_array do |f|
  f.name                  { Factory.next :storage_array_name }
  f.description           { |storage_array| "#{storage_array.name} description" }
end

