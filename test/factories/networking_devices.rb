Factory.sequence :networking_device_name do |n|
  "networking_device#{n}"
end

Factory.define :networking_device do |f|
  f.name                  { Factory.next :networking_device_name }
  f.description           { |networking_device| "#{networking_device.name} description" }
end

