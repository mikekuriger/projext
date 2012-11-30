require 'test_helper'

class UserTest < ActiveSupport::TestCase
  should have_many :assignments, :roles
  
  context 'A user' do
    setup do
      @user = Factory(:user)
    end
    
    should 'be authenticatable' do
      assert @user.authenticated?(@user.password)
    end
    
    should 'allow an existing role to be added' do
      @user.roles.clear
      @user.add_role(Role.first.name)
      assert @user.roles.first.name, Role.first.name
    end
    
    should 'allow a non-existing role to be added' do
      @user.roles.clear
      @user.add_role!('blarg')
      assert @user.roles.first.name, 'blarg'
    end
    
    context 'with syseng privileges' do
      setup do
        @user = Factory(:user)
        @user.confirm_email!
        @user.activate
        @user.add_role('syseng')
        @ability = Ability.new(@user)
      end
      should 'be able to manage servers' do
        assert @ability.can?(:manage, Server)
      end
    end
    
    context 'with neteng privileges' do
      setup do
        @user = Factory(:user)
        @user.confirm_email!
        @user.activate
        @user.add_role('neteng')
        @ability = Ability.new(@user)
      end
      should 'be able to manage switches' do
        assert @ability.can?(:manage, Switch)
      end
    end
    
    context 'with webeng privileges' do
      setup do
        @user = Factory(:user)
        @user.confirm_email!
        @user.activate
        @user.add_role('webeng')
        @ability = Ability.new(@user)
      end
      should 'be able to manage clusters' do
        assert @ability.can?(:manage, Cluster)
      end
    end
    
    context 'with admin privileges' do
      setup do
        @user = Factory(:user)
        @user.confirm_email!
        @user.add_role('admin')
        @ability = Ability.new(@user)
      end

      context 'when not yet activated' do
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
      end
      
      context 'when activated' do
        setup do
          @user.activate
          @ability = Ability.new(@user)
        end
        should 'be able to read assets' do
          assert @ability.can?(:read, Asset)
        end
        should 'be able to create assets' do
          assert @ability.can?(:create, Asset)
        end
        should 'be able to destroy assets' do
          assert @ability.can?(:destroy, Asset)
        end
        should 'be able to edit assets' do
          assert @ability.can?(:edit, Asset)
        end
      end
      
      context 'when disabled' do
        setup do
          @user.disable
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
      end
    end
  end
end

# == Schema Information
#
# Table name: users
#
#  id                 :integer(4)      not null, primary key
#  created_at         :datetime
#  updated_at         :datetime
#  email              :string(255)
#  encrypted_password :string(128)
#  salt               :string(128)
#  confirmation_token :string(128)
#  remember_token     :string(128)
#  email_confirmed    :boolean(1)      default(FALSE), not null
#  first_name         :string(255)
#  last_name          :string(255)
#

