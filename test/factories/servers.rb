Factory.sequence :server_name do |n|
  "MyServer#{n}"
end

Factory.sequence :server_serial do |n|
  "serial_number_#{n}"
end

Factory.define :server do |f|
  f.name                  { Factory.next :server_name }
  f.hostname              { |s| "#{s.name}-host" }
  f.domain                { "warnerbros.com" }
  f.description           { "Server description" }
  f.serial                { Factory.next :server_serial }
end
