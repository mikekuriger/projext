require 'test_helper'

class InterfacesControllerTest < ActionController::TestCase
  context 'The public' do
    setup do
      @interface = Factory(:interface)
    end
    context 'on GET to :index' do
      setup do
        get :index
      end
      should_redirect_to('sign-in page') { sign_in_url }
    end
    
    context 'on GET to :show' do
      context 'with existing interface ID' do
        setup do
          get :show, :id => @interface.id
        end
        should_redirect_to('sign-in page') { sign_in_url }
      end
      context 'with non-existent interface ID' do
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
        get :edit, :id => @interface.id
      end
      should_redirect_to('sign-in page') { sign_in_url }
    end

    context 'on POST to :create' do
      setup do
        post :create, :interface => Factory.attributes_for(:interface)
      end
      should_redirect_to('sign-in page') { sign_in_url }
    end

    context 'on PUT to :update' do
      setup do
        put :update, :id => @interface.id, :interface => Factory.attributes_for(:interface)
      end
      should_redirect_to('sign-in page') { sign_in_url }
    end

    context 'on DELETE to :destroy' do
      setup do
        delete :destroy, :id => @interface.id
      end
      should_redirect_to('sign-in page') { sign_in_url }
    end
    
  end
  
  context 'A signed-in user' do
    setup do
      @user = Factory(:user)
      @user.confirm_email!
      @user.activate
      @controller.current_user = @user
    end
    
    context 'with admin privileges' do
      setup do
        @user.add_role('admin')
        @interface = Factory(:interface)
      end

      context 'on GET to :index' do
        setup do
          get :index
        end
        should_respond_with :success
        should_render_template(:index)
        should_assign_to(:interfaces)
      end
      
      context 'on GET to :show' do
        context 'with existing interface ID' do
          setup do
             get :show, :id => @interface.id
          end
          should_respond_with :success
          should_render_template(:show)
          should_assign_to(:interface)
        end
        context 'with non-existant interface ID' do
          setup do
            get :show, :id => 0
          end
          should_set_the_flash_to "Couldn't find that interface"
          should_redirect_to('home page') { root_url }
        end
      end
      
      context 'on GET to :new' do
        setup do
          get :new
        end
        should_respond_with(:success)
        should_render_template(:new)
        should_assign_to(:interface)
      end
      
      context 'on POST to :create' do
        context 'given valid parameters' do
          setup do
            post :create, :interface => Factory.attributes_for(:interface)
          end
          should_set_the_flash_to 'Successfully created interface.'
          should_redirect_to('the interface') { interface_url(assigns(:interface)) }
        end
        context 'given invalid parameters' do
          setup do
            post :create, :interface => { }
          end
          should_respond_with(:success)
          should_render_template(:new)
        end
      end
      
      context 'on GET to :edit' do
        setup do
          get :edit, :id => @interface.id
        end
        should_respond_with(:success)
        should_render_template(:edit)
        should_assign_to(:interface)
      end
      
      context 'on PUT to :update' do
        context 'given valid parameters' do
          setup do
            put :update, :id => @interface.id, :interface => Factory.attributes_for(:interface)
          end
          should_set_the_flash_to 'Successfully updated interface.'
          should_redirect_to('the interface') { interface_url(assigns(:interface)) }
          should_assign_to(:interface)
        end
        context 'given invalid parameters' do
          setup do
            put :update, :id => @interface.id, :interface => { :name => nil }
          end
          should_respond_with(:success)
          should_render_template(:edit)
          should_assign_to(:interface)
        end
      end

      context 'on DELETE to :destroy' do
        setup do
          delete :destroy, :id => @interface.id
        end
        should_set_the_flash_to 'Successfully destroyed interface.'
        should_redirect_to('the interface index') { interfaces_url }
      end
    end
    
    context 'with read-only privileges' do
      setup do
        @user.remove_role('admin')
        @user.add_role('executive')
        @interface = Factory(:interface)
      end
      
      context 'on GET to :index' do
        setup do
          get :index
        end
        should_respond_with :success
        should_render_template(:index)
        should_assign_to(:interfaces)
      end

      context 'on GET to :show' do
        context 'with existing interface ID' do
          setup do
             get :show, :id => @interface.id
          end
          should_respond_with :success
          should_render_template(:show)
          should_assign_to(:interface)
        end
        context 'with non-existent interface ID' do
          setup do
            get :show, :id => 0
          end
          should_set_the_flash_to "Couldn't find that interface"
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
            post :create, :interface => Factory.attributes_for(:interface)
          end
          should_redirect_to('home page') { root_url }
        end
        context 'given invalid parameters' do
          setup do
            post :create, :interface => { }
          end
          should_redirect_to('home page') { root_url }
        end
      end
      
      context 'on GET to :edit' do
        setup do
          get :edit, :id => @interface.id
        end
        should_redirect_to('home page') { root_url }
      end
      
      context 'on PUT to :update' do
        context 'given valid parameters' do
          setup do
            put :update, :id => @interface.id, :interface => Factory.attributes_for(:interface)
          end
          should_redirect_to('home page') { root_url }
        end
        context 'given invalid parameters' do
          setup do
            put :update, :id => @interface.id, :interface => { :name => nil }
          end
          should_redirect_to('home page') { root_url }
        end
      end

      context 'on DELETE to :destroy' do
        setup do
          delete :destroy, :id => @interface.id
        end
        should_redirect_to('home page') { root_url }
      end
    end
  end
end
