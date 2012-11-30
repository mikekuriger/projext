Factory.sequence :room_name do |n|
  "room#{n}"
end

Factory.define :room do |f|
  f.name                  { Factory.next :room_name }
  f.description           { |room| "#{room.name} description" }
end
