#!/usr/bin/ruby

require '../lib/ip_admin.rb'
require 'test/unit'



class TestMethods < Test::Unit::TestCase

    def test_compare        
        cidr4_1 = IPAdmin::CIDR.new('192.168.1.0/24')
        cidr4_2 = IPAdmin::CIDR.new('192.168.1.0/25')
        cidr4_3 = IPAdmin::CIDR.new('192.168.2.0/24')
        cidr4_4 = IPAdmin::CIDR.new('192.168.2.64/26')
        cidr4_5 = IPAdmin::CIDR.new('192.168.1.128/25')
                
        cidr6_1 = IPAdmin::CIDR.new('fec0::0/10')
        cidr6_2 = IPAdmin::CIDR.new('fec0::0/64')
        cidr6_3 = IPAdmin::CIDR.new('fe80::0/10')
        cidr6_4 = IPAdmin::CIDR.new('fe80::0/11')
        
        comp1 = IPAdmin.compare(cidr4_1,cidr4_2)
        comp2 = IPAdmin.compare(cidr4_4,cidr4_3)
        comp3 = IPAdmin.compare('192.168.1.0/24',cidr4_1)
        comp4 = IPAdmin.compare('192.168.1.0/24','192.168.2.0/24')                
        comp5 = IPAdmin.compare(cidr6_1,cidr6_2)
        comp6 = IPAdmin.compare(cidr6_4,cidr6_3)
        comp7 = IPAdmin.compare(cidr6_1,cidr6_1)
        comp8 = IPAdmin.compare('fec0::0/10','fe80::0/10')        
        comp9 = IPAdmin.compare('192.168.1.0/25','192.168.1.128/25')
        comp10 = IPAdmin.compare('192.168.1.0/24','192.168.1.0/25')
        
        assert_equal([cidr4_1,cidr4_2],comp1)
        assert_equal([cidr4_3,cidr4_4],comp2)
        assert_equal(1,comp3)
        assert_nil(comp4)
        assert_equal([cidr6_1,cidr6_2],comp5)
        assert_equal([cidr6_3,cidr6_4],comp6)
        assert_equal(1,comp7)
        assert_nil(comp8)
        assert_nil(comp9)
        assert_equal(['192.168.1.0/24','192.168.1.0/25'],comp10)
        
        assert_raise(ArgumentError){ IPAdmin.compare('1',cidr4_2) }
        assert_raise(ArgumentError){ IPAdmin.compare(cidr4_2, '1') }
        assert_raise(ArgumentError){ IPAdmin.compare(cidr4_1,cidr6_1)}
    end
    
    
    def test_merge
        cidr4 = [IPAdmin::CIDR.new(:CIDR => '192.168.1.0/24'),
                 IPAdmin::CIDR.new(:CIDR => '192.168.1.0/26'),
                 IPAdmin::CIDR.new(:CIDR => '192.168.1.4/30'),
                 IPAdmin::CIDR.new(:CIDR => '192.168.1.0/30'),
                 IPAdmin::CIDR.new(:CIDR => '192.168.1.64/27'),
                 IPAdmin::CIDR.new(:CIDR => '192.168.1.96/27'),
                 IPAdmin::CIDR.new(:CIDR => '192.168.1.128/25'),
                 IPAdmin::CIDR.new(:CIDR => '10.1.0.0/31'),
                 IPAdmin::CIDR.new(:CIDR => '10.1.0.0/24'),
                 IPAdmin::CIDR.new(:CIDR => '10.1.0.2/31'),
                 IPAdmin::CIDR.new(:CIDR => '10.1.0.4/30'),
                 IPAdmin::CIDR.new(:CIDR => '10.1.0.16/28'),
                 IPAdmin::CIDR.new(:CIDR => '10.1.0.32/28'),
                 IPAdmin::CIDR.new(:CIDR => '10.1.0.48/28'),
                 IPAdmin::CIDR.new(:CIDR => '10.1.0.0/27'),
                 IPAdmin::CIDR.new(:CIDR => '10.1.0.64/26'),
                 IPAdmin::CIDR.new(:CIDR => '10.1.0.128/25'),
                 IPAdmin::CIDR.new(:CIDR => '10.1.0.0/27'),
                 IPAdmin::CIDR.new(:CIDR => '10.1.0.0/24')]
        
        cidr4_2 = ['10.0.0.0/9','10.1.0.0/9','10.1.0.0/24',
                   '10.1.0.64/26','10.1.0.128/26','128.0.0.0/2',
                   '129.0.0.0/2','1.1.1.0','1.1.1.1',
                   '1.1.1.3','1.1.1.4','1.1.1.5',
                   '1.1.1.6','1.1.1.7','192.168.1.0/27',
                   '192.168.1.32/27','192.168.1.96/27','192.168.1.128/26',
                   '192.168.1.192/26']       
        
        cidr6 = [IPAdmin::CIDR.new(:CIDR => 'fec0::/16'),
                 IPAdmin::CIDR.new(:CIDR => 'fec0::/17'),
                 IPAdmin::CIDR.new(:CIDR => 'fec0:8000::/18'),
                 IPAdmin::CIDR.new(:CIDR => 'fec0:c000::/18'),
                 IPAdmin::CIDR.new(:CIDR => 'fec0::/64'),
                 IPAdmin::CIDR.new(:CIDR => 'fec0::/66'),
                 IPAdmin::CIDR.new(:CIDR => 'fec0::8000:0:0:0/66'),
                 IPAdmin::CIDR.new(:CIDR => 'fec0::c000:0:0:0/66'),
                 IPAdmin::CIDR.new(:CIDR => 'fec0::/127'),
                 IPAdmin::CIDR.new(:CIDR => 'fec0::2/127')]
        
        merge4 = IPAdmin.merge(cidr4)
        merge4_2 = IPAdmin.merge(:List => cidr4_2, :Objectify => true)
        merge6 = IPAdmin.merge(:List => cidr6)

        assert_equal(5, merge4.length)
        assert_equal(11, merge4_2.length)
        assert_equal(5, merge6.length)
        
        assert_equal('1.1.1.0/31', merge4_2[0].desc)
        
        assert_raise(ArgumentError){ IPAdmin.merge(1) }
        assert_raise(ArgumentError){ IPAdmin.merge({}) }
    end
    
    
    def test_minimum_size
        assert_equal(24, IPAdmin.minimum_size(200))
        assert_equal(96, IPAdmin.minimum_size(:IPCount => 2**32-1, :Version => 6))
        
        assert_raise(ArgumentError){ IPAdmin.minimum_size({}) }
    end
    
    
    def test_pack_ip_addr
        assert_equal(2**128-1, IPAdmin.pack_ip_addr('ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff') )
        assert_equal(1, IPAdmin.pack_ip_addr(:IP => '::1') )
        assert_equal(2**32-1, IPAdmin.pack_ip_addr('255.255.255.255') )
        assert_equal(2**128-1, IPAdmin.pack_ip_addr(:IP => 'ffff:ffff:ffff:ffff:ffff:ffff:255.255.255.255') )
        assert_equal(0, IPAdmin.pack_ip_addr(:IP => '::') )
        assert_equal(2**32-1, IPAdmin.pack_ip_addr(:IP => '::255.255.255.255') )
        assert_equal(0x0a0a0a0a, IPAdmin.pack_ip_addr(:IP => '10.10.10.10') )
        assert_equal(2**127+1, IPAdmin.pack_ip_addr(:IP => '8000::0.0.0.1') )
        assert_equal(0x8080000000000000000080800a0a0a0a, IPAdmin.pack_ip_addr(:IP => '8080::8080:10.10.10.10') )
        assert_equal(0xffff0a010001, IPAdmin.pack_ip_addr(:IP => '::ffff:10.1.0.1') )
        assert_equal(2**127+1, IPAdmin.pack_ip_addr(:IP => '8000::1') )
        assert_equal(1, IPAdmin.pack_ip_addr(:IP => '::1') )
        assert_equal(2**127, IPAdmin.pack_ip_addr(:IP => '8000::') )
        
        assert_raise(ArgumentError){ IPAdmin.pack_ip_addr({}) }
        assert_raise(ArgumentError){ IPAdmin.pack_ip_addr(:IP => '192.168.1.1',:Version => 5) }
        assert_raise(ArgumentError){ IPAdmin.pack_ip_addr(:IP => 0xffffffff,:Version => 4) }
    end
    
    
    def test_pack_ip_netmask
        assert_equal(2**32-1, IPAdmin.pack_ip_netmask(:Netmask => '255.255.255.255') )
        assert_equal(2**32-1, IPAdmin.pack_ip_netmask('32') )
        assert_equal(2**32-1, IPAdmin.pack_ip_netmask(:Netmask => '/32') )
        assert_equal(2**32-1, IPAdmin.pack_ip_netmask(32) )
        assert_equal(2**128-1, IPAdmin.pack_ip_netmask(:Netmask => '128', :Version => 6) )
        assert_equal(2**128-1, IPAdmin.pack_ip_netmask(:Netmask => '/128', :Version => 6) )
        assert_equal(2**128-1, IPAdmin.pack_ip_netmask(:Netmask => 128, :Version => 6) )
        
        assert_raise(ArgumentError){ IPAdmin.pack_ip_netmask({}) }
        assert_raise(ArgumentError){ IPAdmin.pack_ip_netmask(:Netmask => '/24',:Version => 5) }
        assert_raise(ArgumentError){ IPAdmin.pack_ip_netmask(:Netmask => [],:Version => 4) }
    end
    
    
    def test_range
        cidr4_1 = IPAdmin::CIDR.new(:CIDR => '192.168.1.0/24')
        cidr4_2 = IPAdmin::CIDR.new(:CIDR => '192.168.1.50/24')
        cidr4_3 = IPAdmin::CIDR.new(:CIDR => '192.168.1.2/24')
        cidr6_1 = IPAdmin::CIDR.new(:CIDR => 'fec0::/64')
        cidr6_2 = IPAdmin::CIDR.new(:CIDR => 'fec0::32/64')        
        
        assert_equal(['192.168.1.1'], IPAdmin.range(:Boundaries => [cidr4_1,cidr4_2], :Limit => 1) )
        assert_equal(['fec0:0000:0000:0000:0000:0000:0000:0001'], IPAdmin.range(:Boundaries => [cidr6_1,cidr6_2], :Limit => 1) )
        
        list = IPAdmin.range(:Boundaries => ['192.168.1.0/24','192.168.1.50/24'], :Bitstep => 2)        
        assert_equal(25, list.length)
        assert_equal('192.168.1.49', list[24])
        
        list = IPAdmin.range(:Boundaries => [cidr4_1,cidr4_3], :Objectify => true)        
        assert_kind_of(IPAdmin::CIDR, list[0])
        assert_equal('192.168.1.1/32', (list[0]).desc)
        
        assert_raise(ArgumentError){ IPAdmin.range(:Limit => 1) }
        assert_raise(ArgumentError){ IPAdmin.range(:Boundaries => [1,2]) }
        assert_raise(ArgumentError){ IPAdmin.compare('1') }
        assert_raise(ArgumentError){ IPAdmin.range(:Boundaries => [cidr4_1,cidr6_2]) }
    end
    
    
    def test_shorten        
        assert_equal('fec0::', IPAdmin.shorten('fec0:0000:0000:0000:0000:0000:0000:0000') )
        assert_equal('fec0::2:0:0:1', IPAdmin.shorten('fec0:0000:0000:0000:0002:0000:0000:0001') )
        assert_equal('fec0::2:0:0:1', IPAdmin.shorten('fec0:00:0000:0:02:0000:0:1') )
        assert_equal('fec0::2:2:0:0:1', IPAdmin.shorten('fec0:0000:0000:0002:0002:0000:0000:0001') )
        assert_equal('fec0:0:0:1::', IPAdmin.shorten('fec0:0000:0000:0001:0000:0000:0000:0000') )
        assert_equal('fec0:1:1:1:1:1:1:1', IPAdmin.shorten('fec0:0001:0001:0001:0001:0001:0001:0001') )
        assert_equal('fec0:ffff:ffff:0:ffff:ffff:ffff:ffff', IPAdmin.shorten('fec0:ffff:ffff:0000:ffff:ffff:ffff:ffff') )
        assert_equal('fec0:ffff:ffff:ffff:ffff:ffff:ffff:ffff', IPAdmin.shorten('fec0:ffff:ffff:ffff:ffff:ffff:ffff:ffff') )
        assert_equal('fec0::', IPAdmin.shorten('fec0::') )
        assert_equal('fec0::192.168.1.1', IPAdmin.shorten('fec0:0:0:0:0:0:192.168.1.1') )
        
        assert_raise(ArgumentError){ IPAdmin.shorten(1) }   
    end
    
    
    def test_sort
        cidr4_1 = IPAdmin::CIDR.new('192.168.1.0/24')
        cidr4_2 = IPAdmin::CIDR.new('192.168.1.128/25')
        cidr4_3 = IPAdmin::CIDR.new('192.168.1.64/26')
        cidr4_4 = IPAdmin::CIDR.new('192.168.1.0/30')
        cidr4_5 = '192.168.2.0/24'
                
        cidr6_1 = IPAdmin::CIDR.new('fec0::0/64')
        cidr6_2 = IPAdmin::CIDR.new('fec0::0/10')
        cidr6_3 = IPAdmin::CIDR.new('fe80::0/10')
        cidr6_4 = 'fe80::0'
        
        sort1 = IPAdmin.sort([cidr4_1,cidr4_2,cidr4_3,cidr4_4,cidr4_5])
        sort2 = IPAdmin.sort([cidr6_1,cidr6_2,cidr6_3,cidr6_4])
        
        assert_equal([cidr4_1,cidr4_4,cidr4_3,cidr4_2,cidr4_5], sort1)
        assert_equal([cidr6_3,cidr6_4,cidr6_2,cidr6_1], sort2)
        
    end
    
    
    def test_unshorten        
        assert_equal('fec0:0000:0000:0000:0000:0000:0000:0000', IPAdmin.unshorten('fec0::') )
        assert_equal('fec0:0000:0000:0000:0002:0000:0000:0001', IPAdmin.unshorten('fec0::2:0:0:1') )
        assert_equal('fec0:0000:0000:0000:0002:0000:0000:0001', IPAdmin.unshorten('fec0:0:0:0:2:0:0:1') )
        assert_equal('0000:0000:0000:0000:0000:ffff:10.1.0.1', IPAdmin.unshorten('::ffff:10.1.0.1') )           
    
        assert_raise(ArgumentError){ IPAdmin.unshorten(1) }
    end
    
    
    def test_unpack_ip_addr
        assert_equal('255.255.255.255', IPAdmin.unpack_ip_addr(2**32-1) )
        assert_equal('0.0.0.0', IPAdmin.unpack_ip_addr(:Integer => 0, :Version => 4) )
        assert_equal('0000:0000:0000:0000:0000:0000:0000:0000', IPAdmin.unpack_ip_addr(:Integer => 0, :Version => 6) )
        assert_equal('ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff', IPAdmin.unpack_ip_addr(:Integer => 2**128-1) )
        assert_equal('0000:0000:0000:0000:0000:0000:ffff:ffff', IPAdmin.unpack_ip_addr(:Integer => 2**32-1, :Version => 6) )
        assert_equal('0000:0000:0000:0000:0000:ffff:10.1.0.1', IPAdmin.unpack_ip_addr(:Integer => 0xffff0a010001, 
                                                                                      :IPv4Mapped => true,
                                                                                      :Version => 6) )
        
        assert_raise(ArgumentError){ IPAdmin.unpack_ip_addr('1') }
        assert_raise(ArgumentError){ IPAdmin.unpack_ip_addr({}) }
        assert_raise(ArgumentError){ IPAdmin.unpack_ip_addr(:Integer => 0xffffffff,:Version => 5) }
        assert_raise(ArgumentError){ IPAdmin.unpack_ip_addr(:Integer => '1', :Version => 4) }                                                                              
    end
    
    
    def test_unpack_ip_netmask
        assert_equal(32, IPAdmin.unpack_ip_netmask(2**32-1) )
        assert_equal(24, IPAdmin.unpack_ip_netmask(:Integer => (2**32 - 2**8 ) ) )
        assert_equal(128, IPAdmin.unpack_ip_netmask(:Integer => 2**128-1) )
        assert_equal(96, IPAdmin.unpack_ip_netmask(:Integer => (2**128 - 2**32)) )
        
        assert_raise(ArgumentError){ IPAdmin.unpack_ip_netmask('1') }
        assert_raise(ArgumentError){ IPAdmin.unpack_ip_netmask({}) }
        assert_raise(ArgumentError){ IPAdmin.unpack_ip_netmask(:Integer => '1')}        
    end
    
    
    def test_validate_eui
        assert_not_nil(IPAdmin.validate_eui('aa-bb-cc-dd-ee-ff') )
        assert_not_nil(IPAdmin.validate_eui('aabb.ccdd.eeff') )
        assert_not_nil(IPAdmin.validate_eui(:EUI => 'aa:bb:cc:dd:ee:ff') )
        assert_not_nil(IPAdmin.validate_eui(:EUI => 'aabb.ccdd.eeff.1234') )
        
        assert_raise(ArgumentError){ IPAdmin.validate_eui(:EUI => 0xaabbccddeeff) }
        assert_raise(ArgumentError){ IPAdmin.validate_eui() }
        
    end
    
    
    def test_validate_ip_addr
        assert_not_nil(IPAdmin.validate_ip_addr('192.168.1.0') )
        assert_not_nil(IPAdmin.validate_ip_addr('255.255.255.255') )
        assert_not_nil(IPAdmin.validate_ip_addr(:IP => '224.0.0.1') )
        assert_not_nil(IPAdmin.validate_ip_addr(:IP => '0.192.0.1') )
        assert_not_nil(IPAdmin.validate_ip_addr(:IP => '0.0.0.0') )
        assert_not_nil(IPAdmin.validate_ip_addr(0xff0000) )
        assert_not_nil(IPAdmin.validate_ip_addr(:IP => 2**32-1) )
        assert_not_nil(IPAdmin.validate_ip_addr(:IP => 0) )
        
        assert_not_nil(IPAdmin.validate_ip_addr('ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff') )
        assert_not_nil(IPAdmin.validate_ip_addr('::') )
        assert_not_nil(IPAdmin.validate_ip_addr(:IP => 'ffff::1') )
        assert_not_nil(IPAdmin.validate_ip_addr(:IP => '1234:5678:9abc:def0:1234:5678:9abc:def0') )
        assert_not_nil(IPAdmin.validate_ip_addr(:IP => '::1') )
        assert_not_nil(IPAdmin.validate_ip_addr(:IP => 'ffff::') )
        assert_not_nil(IPAdmin.validate_ip_addr(:IP => '0001::1') )
        assert_not_nil(IPAdmin.validate_ip_addr(:IP => '2001:4800::64.39.2.1') )
        assert_not_nil(IPAdmin.validate_ip_addr(:IP => '::1.1.1.1') )
        assert_not_nil(IPAdmin.validate_ip_addr(:IP => '::192.168.255.0') )
        assert_not_nil(IPAdmin.validate_ip_addr(:IP => 2**128-1) )
        assert_not_nil(IPAdmin.validate_ip_addr(:IP => 'fec0:0:0:0:0:0:192.168.1.1') )
        assert_not_nil(IPAdmin.validate_ip_addr(:IP => '8080::8080:10.10.10.10') )
        
        assert_raise(RuntimeError){ IPAdmin.validate_ip_addr(:IP => '') }
        assert_raise(RuntimeError){ IPAdmin.validate_ip_addr(:IP => '10.0') }
        assert_raise(RuntimeError){ IPAdmin.validate_ip_addr(:IP => '192.168.1.256') }
        assert_raise(RuntimeError){ IPAdmin.validate_ip_addr(:IP => '192..168.1.1') }
        assert_raise(RuntimeError){ IPAdmin.validate_ip_addr(:IP => '192.168.1a.255') }
        assert_raise(RuntimeError){ IPAdmin.validate_ip_addr(:IP => '192.168.1.1.1') }
        assert_raise(RuntimeError){ IPAdmin.validate_ip_addr(:IP => 'ff.ff.ff.ff') }
        assert_raise(RuntimeError){ IPAdmin.validate_ip_addr(:IP => 2**128-1, :Version => 4) }
        
        assert_raise(RuntimeError){ IPAdmin.validate_ip_addr(:IP => 'ffff::1111::1111') }
        assert_raise(RuntimeError){ IPAdmin.validate_ip_addr(:IP => 'abcd:efgh::1') }
        assert_raise(RuntimeError){ IPAdmin.validate_ip_addr(:IP => 'fffff::1') }
        assert_raise(RuntimeError){ IPAdmin.validate_ip_addr(:IP => 'fffg::1') }
        assert_raise(RuntimeError){ IPAdmin.validate_ip_addr(:IP => 'ffff:::0::1') }
        assert_raise(RuntimeError){ IPAdmin.validate_ip_addr(:IP => '1:0:0:0:0:0:0:0:1') }
        assert_raise(RuntimeError){ IPAdmin.validate_ip_addr(:IP => '::192.168.256.0') }
        assert_raise(RuntimeError){ IPAdmin.validate_ip_addr(:IP => '::192.168.a3.0') }
        assert_raise(RuntimeError){ IPAdmin.validate_ip_addr(:IP => '::192.168.1.1.0') }
        
        assert_raise(ArgumentError){ IPAdmin.validate_ip_addr({}) }
        assert_raise(ArgumentError){ IPAdmin.validate_ip_addr(:IP => [])}
        assert_raise(ArgumentError){ IPAdmin.validate_ip_addr(:IP => '192.168.1.0', :Version => 5)}
        
    end
    
    
    def test_validate_ip_netmask
        assert_equal(true, IPAdmin.validate_ip_netmask(:Netmask => '255.255.255.255') )
        assert_equal(true, IPAdmin.validate_ip_netmask('32') )
        assert_equal(true, IPAdmin.validate_ip_netmask(:Netmask => '/32') )
        assert_equal(true, IPAdmin.validate_ip_netmask(32) )
        assert_equal(true, IPAdmin.validate_ip_netmask(:Netmask => 0xffffffff, :Packed => true) )
        assert_equal(true, IPAdmin.validate_ip_netmask(:Netmask => '128', :Version => 6) )
        assert_equal(true, IPAdmin.validate_ip_netmask(:Netmask => '/128', :Version => 6) )
        assert_equal(true, IPAdmin.validate_ip_netmask(:Netmask => 128, :Version => 6) )
        
        assert_raise(RuntimeError){ IPAdmin.validate_ip_netmask(:Netmask => '255.192.255.0') }
        assert_raise(RuntimeError){ IPAdmin.validate_ip_netmask(:Netmask => 33) }
        assert_raise(RuntimeError){ IPAdmin.validate_ip_netmask(:Netmask => 129, :Version => 6) }
        
        assert_raise(ArgumentError){ IPAdmin.validate_ip_netmask({}) }
        assert_raise(ArgumentError){ IPAdmin.validate_ip_netmask(:Netmask => [])}
        assert_raise(ArgumentError){ IPAdmin.validate_ip_netmask(:Netmask => '/24', :Version => 5)}
    end 
    
    
end




