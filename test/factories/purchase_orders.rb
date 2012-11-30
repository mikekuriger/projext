Factory.sequence :purchase_order_name do |n|
  "MyPurchaseOrder#{n}"
end

Factory.sequence :purchase_order_number do |n|
  "#{n}"
end

Factory.define :purchase_order do |purchase_order|
  purchase_order.name                  { Factory.next :purchase_order_name }
  purchase_order.description           { "Purchase order description" }
  purchase_order.number                { Factory.next :purchase_order_number }
  purchase_order.association           :vendor, :factory => :vendor
  purchase_order.attachment            { File.new("test/fixtures/upload.pdf") }
end
