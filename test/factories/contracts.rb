Factory.sequence :contract_name do |n|
  "MyContract#{n}"
end

Factory.sequence :contract_number do |n|
  "#{n}"
end

Factory.define :contract do |contract|
  contract.name                  { Factory.next :contract_name }
  contract.description           { "Contract description" }
  contract.number                { Factory.next :contract_number }
  contract.association           :vendor, :factory => :vendor
  contract.attachment            { File.new("test/fixtures/upload.pdf") }
end
