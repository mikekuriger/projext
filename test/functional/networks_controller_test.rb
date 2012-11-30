require 'test_helper'

class NetworksControllerTest < ActionController::TestCase
  context 'The public' do
    setup do
      @network = Factory(:network)
    end
    context 'on GET to :index' do
      setup do
        get :index
      end
      should_redirect_to('sign-in page') { sign_in_url }
    end
    
    context 'on GET to :show' do
      context 'with existing network ID' do
        setup do
          get :show, :id => @network.id
        end
        should_redirect_to('sign-in page') { sign_in_url }
      end
      context 'with non-existent network ID' do
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
        get :edit, :id => @network.id
      end
      should_redirect_to('sign-in page') { sign_in_url }
    end

    context 'on POST to :create' do
      setup do
        post :create, :network => Factory.attributes_for(:network)
      end
      should_redirect_to('sign-in page') { sign_in_url }
    end

    context 'on PUT to :update' do
      setup do
        put :update, :id => @network.id, :network => Factory.attributes_for(:network)
      end
      should_redirect_to('sign-in page') { sign_in_url }
    end

    context 'on DELETE to :destroy' do
      setup do
        delete :destroy, :id => @network.id
      end
      should_redirect_to('sign-in page') { sign_in_url }
    end
    
  end
  
  context 'A signed-in user' do
    setup do
      @user = Factory(:email_confirmed_user)
      @user.activate
      @controller.current_user = @user
    end
    
    context 'with admin privileges' do
      setup do
        @user.add_role('admin')
        @network = Factory(:network)
      end

      context 'on GET to :index' do
        setup do
          get :index
        end
        should_respond_with :success
        should_render_template(:index)
        should_assign_to(:networks)
      end
      
      context 'on GET to :show' do
        context 'with existing network ID' do
          setup do
             get :show, :id => @network.id
          end
          should_respond_with :success
          should_render_template(:show)
          should_assign_to(:network)
        end
        context 'with non-existant network ID' do
          setup do
            get :show, :id => 0
          end
          should_set_the_flash_to "Couldn't find that network"
          should_redirect_to('home page') { root_url }
        end
      end
      
      context 'on GET to :new' do
        setup do
          get :new
        end
        should_respond_with(:success)
        should_render_template(:new)
        should_assign_to(:network)
      end
      
      context 'on POST to :create' do
        context 'given valid parameters' do
          setup do
            post :create, :network => Factory.attributes_for(:network)
          end
          should_set_the_flash_to 'Successfully created network.'
          should_redirect_to('the network') { network_url(assigns(:network)) }
        end
        context 'given invalid parameters' do
          setup do
            post :create, :network => { }
          end
          should_respond_with(:success)
          should_render_template(:new)
        end
      end
      
      context 'on GET to :edit' do
        setup do
          get :edit, :id => @network.id
        end
        should_respond_with(:success)
        should_render_template(:edit)
        should_assign_to(:network)
      end
      
      context 'on PUT to :update' do
        context 'given valid parameters' do
          setup do
            put :update, :id => @network.id, :network => Factory.attributes_for(:network)
          end
          should_set_the_flash_to 'Successfully updated network.'
          should_redirect_to('the network') { network_url(assigns(:network)) }
          should_assign_to(:network)
        end
        context 'given invalid parameters' do
          setup do
            put :update, :id => @network.id, :network => { :network => nil }
          end
          should_respond_with(:success)
          should_render_template(:edit)
          should_assign_to(:network)
        end
      end

      context 'on DELETE to :destroy' do
        setup do
          delete :destroy, :id => @network.id
        end
        should_set_the_flash_to 'Successfully destroyed network.'
        should_redirect_to('the network index') { networks_url }
      end
    end
    
    context 'with read-only privileges' do
      setup do
        @user.remove_role('admin')
        @user.add_role('executive')
        @network = Factory(:network)
      end
      
      context 'on GET to :index' do
        setup do
          get :index
        end
        should_respond_with :success
        should_render_template(:index)
        should_assign_to(:networks)
      end

      context 'on GET to :show' do
        context 'with existing network ID' do
          setup do
             get :show, :id => @network.id
          end
          should_respond_with :success
          should_render_template(:show)
          should_assign_to(:network)
        end
        context 'with non-existent network ID' do
          setup do
            get :show, :id => 0
          end
          should_set_the_flash_to "Couldn't find that network"
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
            post :create, :network => Factory.attributes_for(:network)
          end
          should_redirect_to('home page') { root_url }
        end
        context 'given invalid parameters' do
          setup do
            post :create, :network => { }
          end
          should_redirect_to('home page') { root_url }
        end
      end
      
      context 'on GET to :edit' do
        setup do
          get :edit, :id => @network.id
        end
        should_redirect_to('home page') { root_url }
      end
      
      context 'on PUT to :update' do
        context 'given valid parameters' do
          setup do
            put :update, :id => @network.id, :network => Factory.attributes_for(:network)
          end
          should_redirect_to('home page') { root_url }
        end
        context 'given invalid parameters' do
          setup do
            put :update, :id => @network.id, :network => { :network => nil }
          end
          should_redirect_to('home page') { root_url }
        end
      end

      context 'on DELETE to :destroy' do
        setup do
          delete :destroy, :id => @network.id
        end
        should_redirect_to('home page') { root_url }
      end
    end
  end
end
