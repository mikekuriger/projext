#!/usr/bin/ruby

require '../lib/ip_admin.rb'
require 'test/unit'



class TestEUI < Test::Unit::TestCase

    def test_new
        assert_not_nil(IPAdmin::EUI48.new('aa-bb-cc-dd-ee-ff') )
        assert_not_nil(IPAdmin::EUI48.new(:EUI => 'aa-bb-cc-dd-ee-ff') )
        assert_not_nil(IPAdmin::EUI48.new(:EUI => 'aa:bb:cc:dd:ee:ff') )
        assert_not_nil(IPAdmin::EUI48.new(:EUI => 'aabb.ccdd.eeff') )
        assert_not_nil(IPAdmin::EUI64.new(:EUI => 'aa-bb-cc-dd-ee-ff-00-01') )
        assert_not_nil(IPAdmin::EUI48.new(:PackedEUI => 0x000000000001) )
        assert_not_nil(IPAdmin::EUI64.new(:PackedEUI => 0x0000000000000001) )
        
        assert_raise(RuntimeError){ IPAdmin::EUI.new(:EUI => 'aa-bb-cc-dd-ee-ff-11') }
        assert_raise(ArgumentError){ IPAdmin::EUI.new() }
        assert_raise(ArgumentError){ IPAdmin::EUI.new({}) }
        assert_raise(ArgumentError){ IPAdmin::EUI.new(1) }
    end
    
    def test_simple
        mac = IPAdmin::EUI48.new('aa-bb-cc-dd-ee-ff')        
        assert_equal('aa-bb-cc', mac.oui )
        assert_equal('dd-ee-ff', mac.ei )
        assert_equal(IPAdmin::EUI48, mac.class )
        
        
        mac = IPAdmin::EUI64.new(:EUI => 'aa-bb-cc-dd-ee-ff-01-02')        
        assert_equal('aa-bb-cc', mac.oui )
        assert_equal('dd-ee-ff-01-02', mac.ei )
        assert_equal('aa-bb-cc-dd-ee-ff-01-02', mac.address )
        assert_equal(IPAdmin::EUI64, mac.class )
        
    end
    
    def test_link_local
        mac = IPAdmin::EUI48.new(:EUI => 'aa-bb-cc-dd-ee-ff')        
        assert_equal('fe80:0000:0000:0000:aabb:ccff:fedd:eeff', mac.link_local )
        
        mac = IPAdmin::EUI48.new(:EUI => '1234.5678.9abc')        
        assert_equal('fe80:0000:0000:0000:1234:56ff:fe78:9abc', mac.link_local )
        
        mac = IPAdmin::EUI64.new(:EUI => '1234.5678.9abc.def0')        
        assert_equal('fe80:0000:0000:0000:1234:5678:9abc:def0', mac.link_local(:Objectify => true).ip )
        
    end
    
end
