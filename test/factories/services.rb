Factory.define :service do |f|
  f.association :cluster, :factory => :cluster
  f.association :function, :factory => :function
end
