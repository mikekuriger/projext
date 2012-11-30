Factory.sequence :firewall_name do |n|
  "firewall#{n}"
end

Factory.define :firewall do |f|
  f.name                  { Factory.next :firewall_name }
  f.description           { |firewall| "#{firewall.name} description" }
end

