Factory.sequence :site_name do |n|
  "site#{n}.com"
end

Factory.define :site do |f|
  f.name                  { Factory.next :site_name }
  f.association           :ip, :factory => :ip
  f.association           :cluster, :factory => :cluster
  f.association           :customer, :factory => :customer
end