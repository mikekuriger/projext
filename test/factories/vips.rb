Factory.sequence :vip_name do |n|
  "vip#{n}.com"
end

Factory.define :vip do |f|
  f.name                  { Factory.next :vip_name }
  f.association           :ip, :factory => :ip
end