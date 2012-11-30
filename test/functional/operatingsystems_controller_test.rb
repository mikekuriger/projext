require 'test_helper'

class OperatingsystemsControllerTest < ActionController::TestCase
  context 'The public' do
    setup do
      @operatingsystem = Factory(:operatingsystem)
    end
    context 'on GET to :index' do
      setup do
        get :index
      end
      should_redirect_to('sign-in page') { sign_in_url }
    end
    
    context 'on GET to :show' do
      context 'with existing operatingsystem ID' do
        setup do
          get :show, :id => @operatingsystem.id
        end
        should_redirect_to('sign-in page') { sign_in_url }
      end
      context 'with non-existent operatingsystem ID' do
        setup do
          get :show, :id => 0
        end
        should_redirect_to('home page') { root_url }
      end
    end
    
    context 'on GET to :new' do
      setup do
        get :new
      end
      should_redirect_to('sign-in page') { sign_in_url }
    end

    context 'on GET to :edit' do
      setup do
        get :edit, :id => @operatingsystem.id
      end
      should_redirect_to('sign-in page') { sign_in_url }
    end

    context 'on POST to :create' do
      setup do
        post :create, :operatingsystem => Factory.attributes_for(:operatingsystem)
      end
      should_redirect_to('sign-in page') { sign_in_url }
    end

    context 'on PUT to :update' do
      setup do
        put :update, :id => @operatingsystem.id, :operatingsystem => Factory.attributes_for(:operatingsystem)
      end
      should_redirect_to('sign-in page') { sign_in_url }
    end

    context 'on DELETE to :destroy' do
      setup do
        delete :destroy, :id => @operatingsystem.id
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
        @operatingsystem = Factory(:operatingsystem)
      end

      context 'on GET to :index' do
        setup do
          get :index
        end
        should_respond_with :success
        should_render_template(:index)
        should_assign_to(:operatingsystems)
      end
      
      context 'on GET to :show' do
        context 'with existing operatingsystem ID' do
          setup do
             get :show, :id => @operatingsystem.id
          end
          should_respond_with :success
          should_render_template(:show)
          should_assign_to(:operatingsystem)
        end
        context 'with non-existant operatingsystem ID' do
          setup do
            get :show, :id => 0
          end
          should_set_the_flash_to "Couldn't find that operating system"
          should_redirect_to('home page') { root_url }
        end
      end
      
      context 'on GET to :new' do
        setup do
          get :new
        end
        should_respond_with(:success)
        should_render_template(:new)
        should_assign_to(:operatingsystem)
      end
      
      context 'on POST to :create' do
        context 'given valid parameters' do
          setup do
            post :create, :operatingsystem => Factory.attributes_for(:operatingsystem, { :manufacturer => Factory(:manufacturer) })
          end
          should_set_the_flash_to 'Successfully created operating system.'
          should_redirect_to('the operatingsystem') { operatingsystem_url(assigns(:operatingsystem)) }
        end
        context 'given invalid parameters' do
          setup do
            post :create, :operatingsystem => { }
          end
          should_respond_with(:success)
          should_render_template(:new)
        end
      end
      
      context 'on GET to :edit' do
        setup do
          get :edit, :id => @operatingsystem.id
        end
        should_respond_with(:success)
        should_render_template(:edit)
        should_assign_to(:operatingsystem)
      end
      
      context 'on PUT to :update' do
        context 'given valid parameters' do
          setup do
            put :update, :id => @operatingsystem.id, :operatingsystem => Factory.attributes_for(:operatingsystem, { :manufacturer => Factory(:manufacturer) })
          end
          should_set_the_flash_to 'Successfully updated operating system.'
          should_redirect_to('the operatingsystem') { operatingsystem_url(assigns(:operatingsystem)) }
          should_assign_to(:operatingsystem)
        end
        context 'given invalid parameters' do
          setup do
            put :update, :id => @operatingsystem.id, :operatingsystem => { :ostype => nil }
          end
          should_respond_with(:success)
          should_render_template(:edit)
          should_assign_to(:operatingsystem)
        end
      end

      context 'on DELETE to :destroy' do
        setup do
          delete :destroy, :id => @operatingsystem.id
        end
        should_set_the_flash_to 'Successfully destroyed operating system.'
        should_redirect_to('the operatingsystem index') { operatingsystems_url }
      end
    end
    
    context 'with read-only privileges' do
      setup do
        @user.remove_role('admin')
        @user.add_role('executive')
        @operatingsystem = Factory(:operatingsystem)
      end
      
      context 'on GET to :index' do
        setup do
          get :index
        end
        should_respond_with :success
        should_render_template(:index)
        should_assign_to(:operatingsystems)
      end

      context 'on GET to :show' do
        context 'with existing operatingsystem ID' do
          setup do
             get :show, :id => @operatingsystem.id
          end
          should_respond_with :success
          should_render_template(:show)
          should_assign_to(:operatingsystem)
        end
        context 'with non-existent operatingsystem ID' do
          setup do
            get :show, :id => 0
          end
          should_set_the_flash_to "Couldn't find that operating system"
          should_redirect_to('home page') { root_url }
        end
      end
      
      context 'on GET to :new' do
        setup do
          get :new
        end
        should_redirect_to('home page') { root_url }
      end
      
      context 'on POST to :create' do
        context 'given valid parameters' do
          setup do
            post :create, :operatingsystem => Factory.attributes_for(:operatingsystem)
          end
          should_redirect_to('home page') { root_url }
        end
        context 'given invalid parameters' do
          setup do
            post :create, :operatingsystem => { }
          end
          should_redirect_to('home page') { root_url }
        end
      end
      
      context 'on GET to :edit' do
        setup do
          get :edit, :id => @operatingsystem.id
        end
        should_redirect_to('home page') { root_url }
      end
      
      context 'on PUT to :update' do
        context 'given valid parameters' do
          setup do
            put :update, :id => @operatingsystem.id, :operatingsystem => Factory.attributes_for(:operatingsystem)
          end
          should_redirect_to('home page') { root_url }
        end
        context 'given invalid parameters' do
          setup do
            put :update, :id => @operatingsystem.id, :operatingsystem => { :name => nil }
          end
          should_redirect_to('home page') { root_url }
        end
      end

      context 'on DELETE to :destroy' do
        setup do
          delete :destroy, :id => @operatingsystem.id
        end
        should_redirect_to('home page') { root_url }
      end
    end
  end
end
