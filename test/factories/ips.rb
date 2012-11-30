Factory.sequence :ip_ip do |n|
  IPAddr.new(n, Socket::AF_INET).to_s
end

Factory.define :ip do |ip|
  ip.ip                    { Factory.next :ip_ip }
  ip.association :network, :factory => :network
end
