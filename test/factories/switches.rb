Factory.sequence :switch_name do |n|
  "MyServer#{n}"
end

Factory.sequence :switch_serial do |n|
  "serial_number_#{n}"
end

Factory.define :switch do |f|
  f.name                  { Factory.next :switch_name }
  f.hostname              { |s| "#{s.name}-host" }
  f.domain                { "warnerbros.com" }
  f.description           { "Server description" }
  f.serial                { Factory.next :switch_serial }
end
