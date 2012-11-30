Factory.define :service_assignment do |service_assignment|
  service_assignment.association           :asset, :factory => :asset
  service_assignment.association           :service, :factory => :service
end
