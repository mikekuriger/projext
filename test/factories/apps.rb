Factory.sequence :app_name do |n|
  "app#{n}"
end

Factory.define :app do |f|
  f.name                  { Factory.next :app_name }
  f.description           { |app| "#{app.name} description" }
  f.association           :project, :factory => :project
end

