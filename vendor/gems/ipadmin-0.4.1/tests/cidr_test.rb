#!/usr/bin/ruby

require '../lib/ip_admin.rb'
require 'test/unit'



class TestCIDR < Test::Unit::TestCase

    def test_new
        assert_nothing_raised(Exception){IPAdmin::CIDR.new('192.168.1.0/24')}
        assert_nothing_raised(Exception){IPAdmin::CIDR.new(:CIDR => '192.168.1.0/24') }
        assert_nothing_raised(Exception){IPAdmin::CIDR.new(:CIDR => '192.168.1.0 255.255.255.0')}
        assert_nothing_raised(Exception){IPAdmin::CIDR.new(:CIDR => '192.168.1.1') }
        assert_nothing_raised(Exception){IPAdmin::CIDR.new(:CIDR => '192.168.1.1    ') }
        assert_nothing_raised(Exception){IPAdmin::CIDR.new(:CIDR => 'fec0::/64') }
        assert_nothing_raised(Exception){IPAdmin::CIDR.new(:CIDR => '192.168.1.1/24 255.255.0.0')}
        assert_nothing_raised(Exception){IPAdmin::CIDR.new(:CIDR => 'fec0::1/64')}
        assert_nothing_raised(Exception){IPAdmin::CIDR.new('fec0::1/64')}
        assert_nothing_raised(Exception){IPAdmin::CIDR.new(:PackedIP => 0x0a0a0a0a, :PackedNetmask => 0xffffffff)}
        
        cidr = IPAdmin::CIDR.new(:CIDR => '192.168.1.1 255.255.0.0')
        assert_equal(16, cidr.bits )
        assert_equal(4, cidr.version )
        
        cidr = IPAdmin::CIDR.new(:CIDR => '192.168.1.1/24 255.255.0.0')
        assert_equal(24, cidr.bits )
        assert_equal(4, cidr.version )
        
        cidr = IPAdmin::CIDR.new(:CIDR => 'fec0::1/64')
        assert_equal(64, cidr.bits )
        assert_equal(6, cidr.version )
        
        cidr = IPAdmin::CIDR.new(:CIDR => '10.10.10.10', :PackedIP => 0x0a0000000)
        assert_equal(0x0a0000000, cidr.packed_ip )
        assert_equal(4, cidr.version )
        
        cidr = IPAdmin::CIDR.new(:CIDR => '10.10.10.10/32 255.255.255.0')
        assert_equal(32, cidr.bits )
        assert_equal(4, cidr.version )
        
        cidr = IPAdmin::CIDR.new(:CIDR => '10.10.10.10/32', :PackedNetmask => 0xffffff00)
        assert_equal(24, cidr.bits )
        assert_equal(4, cidr.version )
        
        assert_raise(ArgumentError){ IPAdmin::CIDR.new(1) }
        assert_raise(ArgumentError){ IPAdmin::CIDR.new(:Version => 4) }
        assert_raise(ArgumentError){ IPAdmin::CIDR.new('fec0::1/64 255.255.255.0') }
        assert_raise(RuntimeError){ IPAdmin::CIDR.new(:CIDR => '192.168.1.0 a') }
    end
    
    
    def test_contains?

        cidr4 = IPAdmin::CIDR.new(:CIDR => '192.168.1.0/24')
        cidr4_2 = IPAdmin::CIDR.new(:CIDR => '192.168.1.0/26')
        cidr6 = IPAdmin::CIDR.new(:CIDR => 'fec0::/64')
        cidr6_2 = IPAdmin::CIDR.new(:CIDR => 'fec0::/96')
        
        assert_equal(true,cidr4.contains?('192.168.1.0/26') )
        assert_equal(true,cidr4.contains?(cidr4_2) )
        assert_equal(true,cidr6.contains?(cidr6_2) )
        assert_equal(false,cidr4.contains?('192.168.2.0/26') )
        assert_equal(false,cidr6.contains?('fe80::/96') )
        
        assert_raise(ArgumentError) { cidr4.contains?(1) }
        assert_raise(ArgumentError) { cidr4.contains?(cidr6_2) }       
    end
    
        
    def test_enumerate
        cidr4 = IPAdmin::CIDR.new(:CIDR => '192.168.1.0/24')
        cidr6 = IPAdmin::CIDR.new(:CIDR => 'fec0::/64')
        
        assert_equal(['192.168.1.0', '192.168.1.1'],cidr4.enumerate(:Limit => 2) )
        assert_equal(['fec0:0000:0000:0000:0000:0000:0000:0000'],cidr6.enumerate(:Limit => 1) )
        assert_equal(['fec0::'],cidr6.enumerate(:Limit => 1, :Short => true) )
        
        
        enums4 = cidr4.enumerate(:Limit => 2, :Bitstep => 5)
        enums6 = cidr6.enumerate(:Limit => 2, :Bitstep => 5)
        assert_equal('192.168.1.5', enums4[1] )
        assert_equal('fec0:0000:0000:0000:0000:0000:0000:0005', enums6[1] )
        
        enums4 = cidr4.enumerate(:Objectify => true,:Limit => 1)
        assert_kind_of(IPAdmin::CIDR, enums4[0] )
        
    end
    
    def test_fill_in
        cidr = IPAdmin::CIDR.new('192.168.1.0/24')
        filled = cidr.fill_in(['192.168.1.0/27','192.168.1.44/30',
                               '192.168.1.64/26','192.168.1.129'])
                               
        assert_equal(['192.168.1.0/27','192.168.1.32/29','192.168.1.40/30',
                      '192.168.1.44/30','192.168.1.48/28','192.168.1.64/26',
                      '192.168.1.128/32','192.168.1.129/32','192.168.1.130/31',
                      '192.168.1.132/30','192.168.1.136/29','192.168.1.144/28',
                      '192.168.1.160/27','192.168.1.192/26'],filled)
    end
    
    def test_mcast
        cidr4 = IPAdmin::CIDR.new('224.0.0.1')
        cidr4_2 = IPAdmin::CIDR.new('239.255.255.255')
        cidr4_3 = IPAdmin::CIDR.new('230.2.3.5')
        cidr4_4 = IPAdmin::CIDR.new('235.147.18.23')
        cidr4_5 = IPAdmin::CIDR.new('192.168.1.1')
        cidr6 = IPAdmin::CIDR.new('ff00::1')
        cidr6_2 = IPAdmin::CIDR.new('ffff::1')
        cidr6_3 = IPAdmin::CIDR.new('ff00::ffff:ffff')
        cidr6_4 = IPAdmin::CIDR.new('ff00::fec0:1234:')
        cidr6_5 = IPAdmin::CIDR.new('2001:4800::1')
        
        assert_equal('01-00-5e-00-00-01',cidr4.multicast_mac(:Objectify => true).address )
        assert_equal('01-00-5e-7f-ff-ff',cidr4_2.multicast_mac )
        assert_equal('01-00-5e-02-03-05',cidr4_3.multicast_mac )
        assert_equal('01-00-5e-13-12-17',cidr4_4.multicast_mac )
        
        assert_equal('33-33-00-00-00-01',cidr6.multicast_mac(:Objectify => true).address )
        assert_equal('33-33-00-00-00-01',cidr6_2.multicast_mac )
        assert_equal('33-33-ff-ff-ff-ff',cidr6_3.multicast_mac )
        assert_equal('33-33-fe-c0-12-34',cidr6_4.multicast_mac )
        
        assert_raise(RuntimeError){ cidr4_5.multicast_mac }
        assert_raise(RuntimeError){ cidr6_5.multicast_mac }        
    end    
    
    def test_next_ip
        cidr4 = IPAdmin::CIDR.new('192.168.1.0/24')
        cidr6 = IPAdmin::CIDR.new('fec0::/64')
        
        next4 = cidr4.next_ip()
        next6 = cidr6.next_ip()
        assert_equal('192.168.2.0',next4 )
        assert_equal('fec0:0000:0000:0001:0000:0000:0000:0000',next6 )
        
        next6 = cidr6.next_ip(:Short => true)
        assert_equal('fec0:0:0:1::',next6 )
        
        next4 = cidr4.next_ip(:Bitstep => 2)
        next6 = cidr6.next_ip(:Bitstep => 2)
        assert_equal('192.168.2.1',next4 )
        assert_equal('fec0:0000:0000:0001:0000:0000:0000:0001',next6 )
        
        next4 = cidr4.next_ip(:Objectify => true)
        next6 = cidr6.next_ip(:Objectify => true)
        assert_equal('192.168.2.0/32',next4.desc )
        assert_equal('fec0:0000:0000:0001:0000:0000:0000:0000/128',next6.desc )
        
    end
    
    def test_next_subnet
        cidr4 = IPAdmin::CIDR.new('192.168.1.0/24')
        cidr6 = IPAdmin::CIDR.new('fec0::/64')
        
        next4 = cidr4.next_subnet()
        next6 = cidr6.next_subnet()
        assert_equal('192.168.2.0/24',next4 )
        assert_equal('fec0:0000:0000:0001:0000:0000:0000:0000/64',next6 )
        
        next6 = cidr6.next_subnet(:Short => true)
        assert_equal('fec0:0:0:1::/64',next6 )
        
        next4 = cidr4.next_subnet(:Bitstep => 2)
        next6 = cidr6.next_subnet(:Bitstep => 2)
        assert_equal('192.168.3.0/24',next4 )
        assert_equal('fec0:0000:0000:0002:0000:0000:0000:0000/64',next6 )
        
        next4 = cidr4.next_subnet(:Objectify => true)
        next6 = cidr6.next_subnet(:Objectify => true)
        assert_equal('192.168.2.0/24',next4.desc )
        assert_equal('fec0:0000:0000:0001:0000:0000:0000:0000/64',next6.desc )
        
    end
    
    def test_nth
        cidr4 = IPAdmin::CIDR.new('192.168.1.0/24')
        cidr6 = IPAdmin::CIDR.new('fec0::/126')
        
        assert_equal('192.168.1.1',cidr4.nth(1) )
        assert_equal('192.168.1.50',cidr4.nth(:Index => 50) )
        assert_kind_of(IPAdmin::CIDR,cidr4.nth(:Index => 1, :Objectify => true) )
        assert_raise(RuntimeError){ cidr4.nth(:Index => 256) }
        assert_raise(ArgumentError){ cidr4.nth() }
        
        assert_equal('fec0:0000:0000:0000:0000:0000:0000:0001',cidr6.nth(:Index => 1) )
        assert_equal('fec0:0000:0000:0000:0000:0000:0000:0003',cidr6.nth(:Index => 3) )
        assert_equal('fec0::1',cidr6.nth(:Index => 1, :Short => true) )
        assert_raise(RuntimeError){ cidr6.nth(:Index => 10) }
        
        assert_raise(ArgumentError) { cidr4.nth({}) }
    end
    
    def test_range
        cidr4 = IPAdmin::CIDR.new('192.168.1.0/24')
        cidr6 = IPAdmin::CIDR.new('fec0::/64')
        
        range4 = cidr4.range(:Indexes => [25,0], :Bitstep => 5)
        range6 = cidr6.range(:Indexes => [25,0], :Bitstep => 5, :Short => true)
        
        assert_equal(6,range4.length)
        assert_equal(6,range6.length)
        assert_equal('192.168.1.0',range4[0])
        assert_equal('192.168.1.25',range4[5])
        assert_equal('fec0::',range6[0])
        assert_equal('fec0::19',range6[5])
    end
    
    def test_remainder
        cidr4 = IPAdmin::CIDR.new(:CIDR => '192.168.1.0/24')
        cidr4_2 = IPAdmin::CIDR.new(:CIDR => '192.168.1.64/26')
        remainder = cidr4.remainder(:Exclude => cidr4_2)
        
        assert_equal(2,remainder.length)
        assert_equal('192.168.1.0/26',remainder[0])
        
        remainder = cidr4.remainder(:Exclude => '192.168.1.64/26', :Objectify => true)
        assert_equal('192.168.1.128/25',remainder[1].desc)
    end
    
    def test_resize
        cidr4 = IPAdmin::CIDR.new(:CIDR => '192.168.1.129/24')
        cidr6 = IPAdmin::CIDR.new(:CIDR => 'fec0::1/64')
        
        new4 = cidr4.resize(:Netmask => 23)
        new6 = cidr6.resize(63)
        assert_equal('192.168.0.0/23',new4.desc )
        assert_equal('fec0::/63',new6.desc(:Short => true) )
        
        cidr4.resize!(:Netmask => 25)
        cidr6.resize!(:Netmask => 67)
        assert_equal('192.168.1.0/25',cidr4.desc )
        assert_equal('192.168.1.0',cidr4.ip )
        assert_equal('fec0:0000:0000:0000:0000:0000:0000:0000/67',cidr6.desc )
    end
    
    def test_simple_methods
        cidr4 = IPAdmin::CIDR.new(:CIDR => '192.168.1.1/24')
        cidr4_2 = IPAdmin::CIDR.new(:CIDR => '192.168.1.0/26')
        cidr6 = IPAdmin::CIDR.new(:CIDR => 'fec0::1/64')
        cidr6_2 = IPAdmin::CIDR.new(:CIDR => 'fec0::/96')

        assert_equal('1.168.192.in-addr.arpa.', cidr4.arpa() )
        assert_equal('0.0.0.0.0.0.0.0.0.0.0.0.0.c.e.f.ip6.arpa.', cidr6.arpa() )
        
        assert_equal('192.168.1.0/24',cidr4.desc() )
        assert_equal('fec0:0000:0000:0000:0000:0000:0000:0000/64',cidr6.desc() )
        
        assert_equal('fec0::/64',cidr6.desc(:Short => true) )
        
        assert_equal('0.0.0.255',cidr4.hostmask_ext() )        
        
        assert_equal(24,cidr4.bits() )
        assert_equal(64,cidr6.bits() )
        
        assert_equal('192.168.1.1',cidr4.ip() )
        assert_equal('fec0:0000:0000:0000:0000:0000:0000:0001',cidr6.ip() )
        assert_equal('fec0::1',cidr6.ip(:Short => true) )
        
        assert_equal('192.168.1.255',cidr4.last() )
        assert_equal('fec0:0000:0000:0000:ffff:ffff:ffff:ffff',cidr6.last() )
        assert_equal('fec0::ffff:ffff:ffff:ffff',cidr6.last(:Short => true) )
        
        assert_equal('/24',cidr4.netmask() )
        assert_equal('/64',cidr6.netmask() )
        
        assert_equal('255.255.255.0',cidr4.netmask_ext() )        
        
        assert_equal('192.168.1.0',cidr4.network() )
        assert_equal('fec0:0000:0000:0000:0000:0000:0000:0000',cidr6.network() )
        assert_equal('fec0::',cidr6.network(:Short => true) )
        
        assert_equal(256,cidr4.size() )
        assert_equal(2**64,cidr6.size() )       
    end
    
    def test_subnet
        cidr4 = IPAdmin::CIDR.new(:CIDR => '192.168.1.0/24')
        cidr6 = IPAdmin::CIDR.new(:CIDR => 'fec0::/64') 
        
        subnet4 = cidr4.subnet(:Subnet => 26, :MinCount => 4)
        subnet6 = cidr6.subnet(:Subnet => 66, :MinCount => 4)
        assert_equal('192.168.1.0/26', subnet4[0])
        assert_equal('fec0:0000:0000:0000:0000:0000:0000:0000/66', subnet6[0])        
        
        subnet4 = cidr4.subnet(:Subnet => 26, :MinCount => 1)
        assert_equal('192.168.1.0/26', subnet4[0])
        assert_equal('192.168.1.64/26', subnet4[1])
        assert_equal('192.168.1.128/25', subnet4[2])
        
        subnet4 = cidr4.subnet(:Subnet => 28, :MinCount => 3, :Objectify => true)
        assert_equal('192.168.1.0/28', subnet4[0].desc)
        assert_equal('192.168.1.16/28', subnet4[1].desc)
        assert_equal('192.168.1.32/28', subnet4[2].desc)
        assert_equal('192.168.1.48/28', subnet4[3].desc)
        assert_equal('192.168.1.64/26', subnet4[4].desc)
        assert_equal('192.168.1.128/25', subnet4[5].desc)
        
        subnet4 = cidr4.subnet(:IPCount => 112)
        assert_equal('192.168.1.0/25', subnet4[0])
        
        subnet4 = cidr4.subnet(:IPCount => 31)
        assert_equal('192.168.1.0/27', subnet4[0])

        
    end

    
end




