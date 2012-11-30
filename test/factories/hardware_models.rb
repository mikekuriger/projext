Factory.sequence :hardware_model_name do |n|
  "hardware_model#{n}"
end

Factory.define :hardware_model do |f|
  f.name                  { Factory.next :hardware_model_name }
  f.description           { |hardware_model| "#{hardware_model.name} description" }
  f.association           :manufacturer, :factory => :manufacturer
end
