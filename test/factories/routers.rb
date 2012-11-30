Factory.sequence :router_name do |n|
  "router#{n}"
end

Factory.define :router do |f|
  f.name                  { Factory.next :router_name }
  f.description           { |router| "#{router.name} description" }
end

