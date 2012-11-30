Factory.sequence :interface_name do |n|
  "MyInterface#{n}"
end

Factory.define :interface do |f|
  f.name                  { Factory.next :interface_name }
  f.description           { |i| "#{i.name} description" }
  f.association           :asset, :factory => :asset
  f.mac                   { '00:00:00:00:00:00' }
end
