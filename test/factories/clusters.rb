Factory.sequence :cluster_name do |n|
  "MyCluster#{n}"
end

Factory.define :cluster do |cluster|
  cluster.name                  { Factory.next :cluster_name }
  cluster.description           { |a| "#{a.name} description" }
end
