require 'test_helper'

class VirtualServersControllerTest < ActionController::TestCase
  context 'The public' do
    setup do
      @virtual_server = Factory(:virtual_server)
    end
    context 'on GET to :index' do
      setup do
        get :index
      end
      should_redirect_to('sign-in page') { sign_in_url }
    end
    
    context 'on GET to :show' do
      context 'with existing virtual server ID' do
        setup do
          get :show, :id => @virtual_server.id
        end
        should_redirect_to('sign-in page') { sign_in_url }
      end
      context 'with non-existent virtual server ID' do
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
        get :edit, :id => @virtual_server.id
      end
      should_redirect_to('sign-in page') { sign_in_url }
    end

    context 'on POST to :create' do
      setup do
        post :create, :virtual_server => Factory.attributes_for(:virtual_server)
      end
      should_redirect_to('sign-in page') { sign_in_url }
    end

    context 'on PUT to :update' do
      setup do
        put :update, :id => @virtual_server.id, :virtual_server => Factory.attributes_for(:virtual_server)
      end
      should_redirect_to('sign-in page') { sign_in_url }
    end

    context 'on DELETE to :destroy' do
      setup do
        delete :destroy, :id => @virtual_server.id
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
        @virtual_server = Factory(:virtual_server)
      end

      context 'on GET to :index' do
        setup do
          get :index
        end
        should_respond_with :success
        should_render_template(:index)
        should_assign_to(:virtual_servers)
      end
      
      context 'on GET to :show' do
        context 'with existing virtual server ID' do
          setup do
             get :show, :id => @virtual_server.id
          end
          should_respond_with :success
          should_render_template(:show)
          should_assign_to(:virtual_server)
        end
        context 'with non-existant virtual server ID' do
          setup do
            get :show, :id => 0
          end
          should_set_the_flash_to "Couldn't find that virtual server"
          should_redirect_to('home page') { root_url }
        end
      end
      
      context 'on GET to :new' do
        setup do
          get :new
        end
        should_respond_with(:success)
        should_render_template(:new)
        should_assign_to(:virtual_server)
      end
      
      context 'on POST to :create' do
        context 'given valid parameters' do
          setup do
            post :create, :virtual_server => Factory.attributes_for(:virtual_server)
          end
          should_set_the_flash_to 'Successfully created virtual server.'
          should_redirect_to('the virtual server') { virtual_server_url(assigns(:virtual_server)) }
        end
        context 'given invalid parameters' do
          setup do
            post :create, :virtual_server => { }
          end
          should_respond_with(:success)
          should_render_template(:new)
        end
      end
      
      context 'on GET to :edit' do
        setup do
          get :edit, :id => @virtual_server.id
        end
        should_respond_with(:success)
        should_render_template(:edit)
        should_assign_to(:virtual_server)
      end
      
      context 'on PUT to :update' do
        context 'given valid parameters' do
          setup do
            put :update, :id => @virtual_server.id, :virtual_server => Factory.attributes_for(:virtual_server)
          end
          should_set_the_flash_to 'Successfully updated virtual server.'
          should_redirect_to('the virtual server') { virtual_server_url(assigns(:virtual_server)) }
          should_assign_to(:virtual_server)
        end
        context 'given invalid parameters' do
          setup do
            put :update, :id => @virtual_server.id, :virtual_server => { :name => nil }
          end
          should_respond_with(:success)
          should_render_template(:edit)
          should_assign_to(:virtual_server)
        end
      end

      context 'on DELETE to :destroy' do
        setup do
          delete :destroy, :id => @virtual_server.id
        end
        should_set_the_flash_to 'Successfully destroyed virtual server.'
        should_redirect_to('the virtual server index') { virtual_servers_url }
      end
    end
    
    context 'with read-only privileges' do
      setup do
        @user.remove_role('admin')
        @user.add_role('executive')
        @virtual_server = Factory(:virtual_server)
      end
      
      context 'on GET to :index' do
        setup do
          get :index
        end
        should_respond_with :success
        should_render_template(:index)
        should_assign_to(:virtual_servers)
      end

      context 'on GET to :show' do
        context 'with existing virtual server ID' do
          setup do
             get :show, :id => @virtual_server.id
          end
          should_respond_with :success
          should_render_template(:show)
          should_assign_to(:virtual_server)
        end
        context 'with non-existent virtual server ID' do
          setup do
            get :show, :id => 0
          end
          should_set_the_flash_to "Couldn't find that virtual server"
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
            post :create, :virtual_server => Factory.attributes_for(:virtual_server)
          end
          should_redirect_to('home page') { root_url }
        end
        context 'given invalid parameters' do
          setup do
            post :create, :virtual_server => { }
          end
          should_redirect_to('home page') { root_url }
        end
      end
      
      context 'on GET to :edit' do
        setup do
          get :edit, :id => @virtual_server.id
        end
        should_redirect_to('home page') { root_url }
      end
      
      context 'on PUT to :update' do
        context 'given valid parameters' do
          setup do
            put :update, :id => @virtual_server.id, :virtual_server => Factory.attributes_for(:virtual_server)
          end
          should_redirect_to('home page') { root_url }
        end
        context 'given invalid parameters' do
          setup do
            put :update, :id => @virtual_server.id, :virtual_server => { :name => nil }
          end
          should_redirect_to('home page') { root_url }
        end
      end

      context 'on DELETE to :destroy' do
        setup do
          delete :destroy, :id => @virtual_server.id
        end
        should_redirect_to('home page') { root_url }
      end
    end
  end

end
