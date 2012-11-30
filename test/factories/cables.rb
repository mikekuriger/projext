Factory.define :cable do |cable|
  cable.association           :interface, :factory => :interface
  cable.association           :interface_target, :factory => :interface
  cable.association           :medium, :factory => :medium
end
