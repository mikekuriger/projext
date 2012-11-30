require 'test_helper'

class SwitchTest < ActiveSupport::TestCase
  # Some of these tests probably aren't necessary, since they are being done at the asset level
  should_validate_presence_of :name, :message => "Asset name can't be blank"
  should_validate_presence_of :hostname, :message => "Switch hostname can't be blank"
  should_validate_uniqueness_of :hostname, :scoped_to => :domain, :message => "Hostname must be unique"

  context 'A switch' do
    setup do
      @switch = Factory(:switch, :hostname => 'testswitch', :domain => 'warnerbros.com')
    end

    should 'have the correct FQDN' do
      assert_equal @switch.fqdn, 'testswitch.warnerbros.com'
    end
    
    should 'be in the new state' do
      assert_equal @switch.state, 'new'
    end
    
    context 'with no serial' do
      setup do
        @switch.serial = nil
      end
      should 'not allow transition to received state' do
        @switch.receive
        assert_equal @switch.state, 'new'
      end
    end
    
    context 'with a serial' do
      setup do
        @switch.serial = '123456'
      end
      should 'allow transition to received state' do
        @switch.receive
        assert_equal @switch.state, 'received'
      end
    end
    
    context 'that has been received' do
      setup do
        @switch = Factory(:switch)
        @switch.receive
      end
      should 'have a serial' do
        assert @switch.serial
      end
      
      should 'allow transition to installed state' do
        @switch.install
        assert_equal @switch.state, 'installed'
      end
    end
    
    context 'that has been installed' do
      # should 'have a location' do
      # end
      
      should 'allow transition to in_service state' do
        @switch.make_in_service
        assert_equal @switch.state, 'in_service'
      end
    end
    
    context 'that is in service' do
      setup do
        @switch = Factory(:switch)
        @switch.receive
        @switch.install
        @switch.make_in_service
      end
      should 'allow transition to out_of_service state' do
        @switch.make_out_of_service
        assert_equal @switch.state, 'out_of_service'
      end
    end
    
    context 'that is out of service' do
      should 'allow transition to decommissioned state' do
        @switch.decommission
        assert_equal @switch.state, 'decommissioned'
      end
    end
    
    context 'that is decommissioned' do
      should 'allow transition to disposed state' do
        @switch.dispose
        assert_equal @switch.state, 'disposed'
      end
    end
  end 
end
