Factory.sequence :operatingsystem_name do |n|
  "operatingsystem#{n}"
end

Factory.define :operatingsystem do |f|
  f.name                  { Factory.next :operatingsystem_name }
  f.description           { |operatingsystem| "#{operatingsystem.name} description" }
  f.association           :manufacturer, :factory => :manufacturer
  f.ostype                { |operatingsystem| "#{operatingsystem.name} type" }
end