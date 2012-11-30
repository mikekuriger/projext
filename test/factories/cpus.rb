Factory.sequence :cpu_speed do |n|
  "#{n} MHz"
end

Factory.define :cpu do |f|
  f.association           :manufacturer, :factory => :manufacturer
  f.cpu_type              { "Xeon" }
  f.cores                 { 4 }
  f.speed                 { Factory.next :cpu_speed }
end

