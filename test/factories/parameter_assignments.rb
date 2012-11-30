Factory.sequence :parameter_assignment_value do |n|
  "value#{n}"
end

Factory.define :parameter_assignment do |f|
  f.association           :parameter, :factory => :parameter
  f.value                 { Factory.next :parameter_assignment_value }
end

