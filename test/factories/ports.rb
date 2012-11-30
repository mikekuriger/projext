Factory.sequence :port_name do |n|
  "port#{n}"
end

Factory.define :port do |f|
  f.name                  { Factory.next :port_name }
  f.description           { |port| "#{port.name} description" }
end

