Factory.sequence :load_balancer_name do |n|
  "load_balancer#{n}"
end

Factory.define :load_balancer do |f|
  f.name                  { Factory.next :load_balancer_name }
  f.description           { |load_balancer| "#{load_balancer.name} description" }
end

