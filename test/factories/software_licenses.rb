Factory.sequence :software_license_name do |n|
  "software_license#{n}"
end

Factory.sequence :software_license_serial do |n|
  "softwareserial#{n}"
end

Factory.define :software_license do |f|
  f.name                  { Factory.next :software_license_name }
  f.description           { |software_license| "#{software_license.name} description" }
  f.serial                { Factory.next :software_license_serial }
end

