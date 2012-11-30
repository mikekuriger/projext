Factory.sequence :virtual_server_name do |n|
  "MyVirtualServer#{n}"
end

Factory.sequence :virtual_server_serial do |n|
  "vs_serial_number_#{n}"
end

Factory.define :virtual_server do |f|
  f.name                  { Factory.next :virtual_server_name }
  f.hostname              { |s| "#{s.name}-vs" }
  f.domain                { "warnerbros.com" }
  f.description           { "Virtual server description" }
  f.serial                { Factory.next :virtual_server_serial }
end
