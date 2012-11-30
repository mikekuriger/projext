Factory.sequence :quote_name do |n|
  "MyQuote#{n}"
end

Factory.sequence :quote_number do |n|
  "#{n}"
end

Factory.define :quote do |quote|
  quote.name                  { Factory.next :quote_name }
  quote.description           { "Quote description" }
  quote.number                { Factory.next :quote_number }
  quote.association           :vendor, :factory => :vendor
  quote.attachment            { File.new("test/fixtures/upload.pdf") }
end
