require 'test_helper'

class ServicesControllerTest < ActionController::TestCase
  context 'The public' do
    setup do
      @service = Factory(:service)
    end
    context 'on GET to :index' do
      setup do
        get :index
      end
      should_redirect_to('sign-in page') { sign_in_url }
    end
    
    context 'on GET to :show' do
      context 'with existing service ID' do
        setup do
          get :show, :id => @service.id
        end
        should_redirect_to('sign-in page') { sign_in_url }
      end
      context 'with non-existent service ID' do
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
        get :edit, :id => @service.id
      end
      should_redirect_to('sign-in page') { sign_in_url }
    end

    context 'on POST to :create' do
      setup do
        post :create, :service => Factory.attributes_for(:service)
      end
      should_redirect_to('sign-in page') { sign_in_url }
    end

    context 'on PUT to :update' do
      setup do
        put :update, :id => @service.id, :service => Factory.attributes_for(:service)
      end
      should_redirect_to('sign-in page') { sign_in_url }
    end

    context 'on DELETE to :destroy' do
      setup do
        delete :destroy, :id => @service.id
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
        @service = Factory(:service)
      end

      context 'on GET to :index' do
        setup do
          get :index
        end
        should_respond_with :success
        should_render_template(:index)
        should_assign_to(:services)
      end
      
      context 'on GET to :show' do
        context 'with existing service ID' do
          setup do
             get :show, :id => @service.id
          end
          should_respond_with :success
          should_render_template(:show)
          should_assign_to(:service)
        end
        context 'with non-existant service ID' do
          setup do
            get :show, :id => 0
          end
          should_set_the_flash_to "Couldn't find that service"
          should_redirect_to('home page') { root_url }
        end
      end
      
      context 'on GET to :new' do
        setup do
          get :new
        end
        should_respond_with(:success)
        should_render_template(:new)
        should_assign_to(:service)
      end
      
      context 'on POST to :create' do
        context 'given valid parameters' do
          setup do
            post :create, :service => Factory.attributes_for(:service, { :cluster_id => Factory(:cluster).id, :function_id => Factory(:function).id })
          end
          should_set_the_flash_to 'Successfully created service.'
          should_redirect_to('the service') { service_url(assigns(:service)) }
        end
        context 'given invalid parameters' do
          setup do
            post :create, :service => { }
          end
          should_respond_with(:success)
          should_render_template(:new)
        end
      end
      
      context 'on GET to :edit' do
        setup do
          get :edit, :id => @service.id
        end
        should_respond_with(:success)
        should_render_template(:edit)
        should_assign_to(:service)
      end
      
      context 'on PUT to :update' do
        context 'given valid parameters' do
          setup do
            put :update, :id => @service.id, :service => Factory.attributes_for(:service, { :cluster_id => Factory(:cluster).id, :function_id => Factory(:function).id })
          end
          should_set_the_flash_to 'Successfully updated service.'
          should_redirect_to('the service') { service_url(assigns(:service)) }
          should_assign_to(:service)
        end
        context 'given invalid parameters' do
          setup do
            put :update, :id => @service.id, :service => { :cluster_id => nil }
          end
          should_respond_with(:success)
          should_render_template(:edit)
          should_assign_to(:service)
        end
      end

      context 'on DELETE to :destroy' do
        setup do
          delete :destroy, :id => @service.id
        end
        should_set_the_flash_to 'Successfully destroyed service.'
        should_redirect_to('the service index') { services_url }
      end
    end
    
    context 'with read-only privileges' do
      setup do
        @user.remove_role('admin')
        @user.add_role('executive')
        @service = Factory(:service)
      end
      
      context 'on GET to :index' do
        setup do
          get :index
        end
        should_respond_with :success
        should_render_template(:index)
        should_assign_to(:services)
      end

      context 'on GET to :show' do
        context 'with existing service ID' do
          setup do
             get :show, :id => @service.id
          end
          should_respond_with :success
          should_render_template(:show)
          should_assign_to(:service)
        end
        context 'with non-existent service ID' do
          setup do
            get :show, :id => 0
          end
          should_set_the_flash_to "Couldn't find that service"
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
            post :create, :service => Factory.attributes_for(:service)
          end
          should_redirect_to('home page') { root_url }
        end
        context 'given invalid parameters' do
          setup do
            post :create, :service => { }
          end
          should_redirect_to('home page') { root_url }
        end
      end
      
      context 'on GET to :edit' do
        setup do
          get :edit, :id => @service.id
        end
        should_redirect_to('home page') { root_url }
      end
      
      context 'on PUT to :update' do
        context 'given valid parameters' do
          setup do
            put :update, :id => @service.id, :service => Factory.attributes_for(:service)
          end
          should_redirect_to('home page') { root_url }
        end
        context 'given invalid parameters' do
          setup do
            put :update, :id => @service.id, :service => { :name => nil }
          end
          should_redirect_to('home page') { root_url }
        end
      end

      context 'on DELETE to :destroy' do
        setup do
          delete :destroy, :id => @service.id
        end
        should_redirect_to('home page') { root_url }
      end
    end
  end
end
