require 'test_helper'

class ServersControllerTest < ActionController::TestCase
  context 'The public' do
    setup do
      @server = Factory(:server)
    end
    context 'on GET to :index' do
      setup do
        get :index
      end
      should_redirect_to('sign-in page') { sign_in_url }
    end
    
    context 'on GET to :show' do
      context 'with existing server ID' do
        setup do
          get :show, :id => @server.id
        end
        should_redirect_to('sign-in page') { sign_in_url }
      end
      context 'with non-existent server ID' do
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
        get :edit, :id => @server.id
      end
      should_redirect_to('sign-in page') { sign_in_url }
    end

    context 'on POST to :create' do
      setup do
        post :create, :server => Factory.attributes_for(:server)
      end
      should_redirect_to('sign-in page') { sign_in_url }
    end

    context 'on PUT to :update' do
      setup do
        put :update, :id => @server.id, :server => Factory.attributes_for(:server)
      end
      should_redirect_to('sign-in page') { sign_in_url }
    end

    context 'on DELETE to :destroy' do
      setup do
        delete :destroy, :id => @server.id
      end
      should_redirect_to('sign-in page') { sign_in_url }
    end
    
  end
  
  context 'A signed-in, active user' do
    setup do
      @user = Factory(:user)
      @user.confirm_email!
      @user.activate
      @controller.current_user = @user
    end
    
    context 'with admin privileges' do
      setup do
        @user.add_role('admin')
        @server = Factory(:server)
      end

      context 'on GET to :index' do
        setup do
          get :index
        end
        should_respond_with :success
        should_render_template(:index)
        should_assign_to(:servers)
      end
      
      context 'on GET to :show' do
        context 'with existing server ID' do
          setup do
             get :show, :id => @server.id
          end
          should_respond_with :success
          should_render_template(:show)
          should_assign_to(:server)
        end
        context 'with non-existant server ID' do
          setup do
            get :show, :id => 0
          end
          should_set_the_flash_to "Couldn't find that server"
          should_redirect_to('home page') { root_url }
        end
      end
      
      context 'on GET to :new' do
        setup do
          get :new
        end
        should_respond_with(:success)
        should_render_template(:new)
        should_assign_to(:server)
      end
      
      context 'on POST to :create' do
        context 'given valid parameters' do
          setup do
            post :create, :server => Factory.attributes_for(:server)
          end
          should_set_the_flash_to 'Successfully created server.'
          should_redirect_to('the server') { server_url(assigns(:server)) }
        end
        context 'given invalid parameters' do
          setup do
            post :create, :server => { }
          end
          should_respond_with(:success)
          should_render_template(:new)
        end
      end
      
      context 'on GET to :edit' do
        setup do
          get :edit, :id => @server.id
        end
        should_respond_with(:success)
        should_render_template(:edit)
        should_assign_to(:server)
      end
      
      context 'on PUT to :update' do
        context 'given valid parameters' do
          setup do
            put :update, :id => @server.id, :server => Factory.attributes_for(:server)
          end
          should_set_the_flash_to 'Successfully updated server.'
          should_redirect_to('the server') { server_url(assigns(:server)) }
          should_assign_to(:server)
        end
        context 'given invalid parameters' do
          setup do
            put :update, :id => @server.id, :server => { :name => nil }
          end
          should_respond_with(:success)
          should_render_template(:edit)
          should_assign_to(:server)
        end
      end

      context 'on DELETE to :destroy' do
        setup do
          delete :destroy, :id => @server.id
        end
        should_set_the_flash_to 'Successfully destroyed server.'
        should_redirect_to('the server index') { servers_url }
      end
    end
    
    context 'with read-only privileges' do
      setup do
        @user.remove_role('admin')
        @user.add_role('executive')
        @server = Factory(:server)
      end
      
      context 'on GET to :index' do
        setup do
          get :index
        end
        should_respond_with :success
        should_render_template(:index)
        should_assign_to(:servers)
      end

      context 'on GET to :show' do
        context 'with existing server ID' do
          setup do
             get :show, :id => @server.id
          end
          should_respond_with :success
          should_render_template(:show)
          should_assign_to(:server)
        end
        context 'with non-existent server ID' do
          setup do
            get :show, :id => 0
          end
          should_set_the_flash_to "Couldn't find that server"
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
            post :create, :server => Factory.attributes_for(:server)
          end
          should_redirect_to('home page') { root_url }
        end
        context 'given invalid parameters' do
          setup do
            post :create, :server => { }
          end
          should_redirect_to('home page') { root_url }
        end
      end
      
      context 'on GET to :edit' do
        setup do
          get :edit, :id => @server.id
        end
        should_redirect_to('home page') { root_url }
      end
      
      context 'on PUT to :update' do
        context 'given valid parameters' do
          setup do
            put :update, :id => @server.id, :server => Factory.attributes_for(:server)
          end
          should_redirect_to('home page') { root_url }
        end
        context 'given invalid parameters' do
          setup do
            put :update, :id => @server.id, :server => { :name => nil }
          end
          should_redirect_to('home page') { root_url }
        end
      end

      context 'on DELETE to :destroy' do
        setup do
          delete :destroy, :id => @server.id
        end
        should_redirect_to('home page') { root_url }
      end
    end
  end
end
