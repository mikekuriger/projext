Factory.sequence :function_name do |n|
  "MyFunction#{n}"
end

Factory.define :function do |function|
  function.name                  { Factory.next :function_name }
  function.description           { |a| "#{a.name} description" }
end
