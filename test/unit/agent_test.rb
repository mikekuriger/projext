require 'test_helper'

class AgentTest < ActiveSupport::TestCase
  should_have_one :server
  
  context 'A newly-created agent user' do
    setup do
      @agent = Factory(:agent)
      @agent.enable_api!
      @ability = Ability.new(@agent)
    end
    
    should 'not have an associated server' do
      assert_nil @agent.server
    end
    should 'be unable to read assets' do
      assert @ability.cannot?(:read, Asset)
    end
    should 'be unable to create assets' do
      assert @ability.cannot?(:create, Asset)
    end
    should 'be unable to destroy assets' do
      assert @ability.cannot?(:destroy, Asset)
    end
    should 'be unable to edit assets' do
      assert @ability.cannot?(:edit, Asset)
    end

    should 'have an API key' do
      assert @agent.api_is_enabled?
    end
    # should 'be authenticatable with the API key' do
    #   assert @agent.authenticated?(@agent.api_key)
    # end
    # should 'not be authenticatable with the password' do
    #   assert (not @agent.authenticated?(@agent.password))
    # end
    
    context 'after activation' do
      setup do
        @agent.activate
        @ability = Ability.new(@agent)
      end
      should 'be able to register only one server' do
        assert @ability.can?(:create, Server)
        @agent.server = Factory(:server)
        @ability = Ability.new(@agent)
        assert @ability.cannot?(:register, Server)
      end
      should 'be able to update its associated server' do
        @agent.server = Factory(:server)
        @ability = Ability.new(@agent)
        assert @ability.can?(:update, @agent.server)
      end
      should 'not be able to delete its associated server' do
        assert @ability.cannot?(:delete, @agent.server)
      end
      
      should 'be unable to read arbitrary assets' do
        assert @ability.cannot?(:read, Asset)
      end
      should 'be unable to create assets' do
        assert @ability.cannot?(:create, Asset)
      end
      should 'be unable to destroy arbitrary assets' do
        assert @ability.cannot?(:destroy, Asset)
      end
      should 'be unable to edit arbitrary assets' do
        assert @ability.cannot?(:edit, Asset)
      end
      should 'be unable to read arbitrary servers' do
        assert @ability.cannot?(:read, Server)
      end
      should 'be unable to edit arbitrary servers' do
        assert @ability.cannot?(:edit, Server)
      end
    end
    
    context 'when disabled' do
      setup do
        @agent.disable
        @agent.server = nil
        @ability = Ability.new(@agent)
      end
      should 'be unable to register a server' do
        assert @ability.cannot?(:register, Server)
      end
      should 'be unable to read its associated server' do
        @agent.server = Factory(:server)
        assert @ability.cannot?(:read, @agent.server)
      end
      should 'be unable to update its associated server' do
        assert @ability.cannot?(:update, @agent.server)
      end
      
      should 'be unable to read arbitrary assets' do
        assert @ability.cannot?(:read, Asset)
      end
      should 'be unable to create assets' do
        assert @ability.cannot?(:create, Asset)
      end
      should 'be unable to destroy assets' do
        assert @ability.cannot?(:destroy, Asset)
      end
      should 'be unable to edit arbitrary assets' do
        assert @ability.cannot?(:edit, Asset)
      end
    end
  end
  
end
