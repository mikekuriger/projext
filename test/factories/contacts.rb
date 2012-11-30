Factory.sequence :contact_name do |n|
  "contact#{n}"
end

Factory.define :contact do |f|
  f.name                  { Factory.next :contact_name }
  f.description           { |contact| "#{contact.name} description" }
end

