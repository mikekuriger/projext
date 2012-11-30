Factory.sequence :network_network do |n|
  IPAddr.new(n+16777215, Socket::AF_INET).to_s
end

Factory.define :network do |network|
  network.network           { Factory.next :network_network }
  network.subnetbits        { 30 }
  network.association       :farm, :factory => :farm
end
