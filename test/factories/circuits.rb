Factory.sequence :circuit_name do |n|
  "circuit#{n}"
end

Factory.define :circuit do |f|
  f.name                  { Factory.next :circuit_name }
  f.description           { |circuit| "#{circuit.name} description" }
end

