require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  context 'The public' do
    setup do
      @user = Factory(:user)
    end
    context 'on GET to :index' do
      setup do
        get :index
      end
      should_redirect_to('sign-in page') { sign_in_url }
    end
    
    context 'on GET to :show' do
      context 'with existing user ID' do
        setup do
          get :show, :id => @user.id
        end
        should_redirect_to('sign-in page') { sign_in_url }
      end
      context 'with non-existent user ID' do
        setup do
          get :show, :id => 0
        end
        should_redirect_to('home page') { root_url }
      end
    end
    
    context 'on GET to :edit' do
      setup do
        get :edit, :id => @user.id
      end
      should_redirect_to('sign-in page') { sign_in_url }
    end

    context 'on PUT to :update' do
      setup do
        put :update, :id => @user.id, :user => Factory.attributes_for(:user)
      end
      should_redirect_to('sign-in page') { sign_in_url }
    end

  end
  
  context 'A signed-in, active user' do
    setup do
      @user = Factory(:email_confirmed_user)
      @user.activate
      @controller.current_user = @user
    end
    
    context 'with admin privileges' do
      setup do
        @user.add_role('admin')
        @user = Factory(:user)
      end

      context 'on GET to :index' do
        setup do
          get :index
        end
        should_respond_with :success
        should_render_template(:index)
        should_assign_to(:users)
      end
      
      context 'on GET to :show' do
        context 'with existing user ID' do
          setup do
             get :show, :id => @user.id
          end
          should_respond_with :success
          should_render_template(:show)
          should_assign_to(:user)
        end
        context 'with non-existant user ID' do
          setup do
            get :show, :id => 0
          end
          should_set_the_flash_to "Couldn't find that user"
          should_redirect_to('home page') { root_url }
        end
      end
      
      context 'on GET to :edit' do
        setup do
          get :edit, :id => @user.id
        end
        should_respond_with(:success)
        should_render_template(:edit)
        should_assign_to(:user)
      end
      
      context 'on PUT to :update' do
        context 'given valid parameters' do
          setup do
            put :update, :id => @user.id, :user => Factory.attributes_for(:user)
          end
          should_set_the_flash_to 'Successfully updated user.'
          should_redirect_to('the user') { user_url(assigns(:user)) }
          should_assign_to(:user)
        end
        context 'given invalid parameters' do
          setup do
            put :update, :id => @user.id, :user => { :email => nil }
          end
          should_respond_with(:success)
          should_render_template(:edit)
          should_assign_to(:user)
        end
      end

    end
    
    context 'with read-only privileges' do
      setup do
        @user.remove_role('admin')
        @user.add_role('executive')
        @user = Factory(:user)
      end
      
      context 'on GET to :index' do
        setup do
          get :index
        end
        should_respond_with :success
        should_render_template(:index)
        should_assign_to(:users)
      end

      context 'on GET to :show' do
        context 'with existing user ID' do
          setup do
             get :show, :id => @user.id
          end
          should_respond_with :success
          should_render_template(:show)
          should_assign_to(:user)
        end
        context 'with non-existent user ID' do
          setup do
            get :show, :id => 0
          end
          should_set_the_flash_to "Couldn't find that user"
          should_redirect_to('home page') { root_url }
        end
      end
      
      context 'on GET to :edit' do
        setup do
          get :edit, :id => @user.id
        end
        should_redirect_to('home page') { root_url }
      end
      
      context 'on PUT to :update' do
        context 'given valid parameters' do
          setup do
            put :update, :id => @user.id, :user => Factory.attributes_for(:user)
          end
          should_redirect_to('home page') { root_url }
        end
        context 'given invalid parameters' do
          setup do
            put :update, :id => @user.id, :user => { :name => nil }
          end
          should_redirect_to('home page') { root_url }
        end
      end

    end
  end
end
