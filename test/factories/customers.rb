Factory.sequence :customer_name do |n|
  "customer#{n}"
end

Factory.define :customer do |f|
  f.name                  { Factory.next :customer_name }
  f.address1              { |customer| "#{customer.name} address" }
  f.zip                   { '12345' }
  f.url                   { 'http://www.wb.com/' }
end
