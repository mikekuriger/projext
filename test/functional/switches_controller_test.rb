require 'test_helper'

class SwitchesControllerTest < ActionController::TestCase
  context 'The public' do
    setup do
      @switch = Factory(:switch)
    end
    context 'on GET to :index' do
      setup do
        get :index
      end
      should_redirect_to('sign-in page') { sign_in_url }
    end
    
    context 'on GET to :show' do
      context 'with existing switch ID' do
        setup do
          get :show, :id => @switch.id
        end
        should_redirect_to('sign-in page') { sign_in_url }
      end
      context 'with non-existent switch ID' do
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
        get :edit, :id => @switch.id
      end
      should_redirect_to('sign-in page') { sign_in_url }
    end

    context 'on POST to :create' do
      setup do
        post :create, :switch => Factory.attributes_for(:switch)
      end
      should_redirect_to('sign-in page') { sign_in_url }
    end

    context 'on PUT to :update' do
      setup do
        put :update, :id => @switch.id, :switch => Factory.attributes_for(:switch)
      end
      should_redirect_to('sign-in page') { sign_in_url }
    end

    context 'on DELETE to :destroy' do
      setup do
        delete :destroy, :id => @switch.id
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
        @switch = Factory(:switch)
      end

      context 'on GET to :index' do
        setup do
          get :index
        end
        should_respond_with :success
        should_render_template(:index)
        should_assign_to(:switches)
      end
      
      context 'on GET to :show' do
        context 'with existing switch ID' do
          setup do
             get :show, :id => @switch.id
          end
          should_respond_with :success
          should_render_template(:show)
          should_assign_to(:switch)
        end
        context 'with non-existant switch ID' do
          setup do
            get :show, :id => 0
          end
          should_set_the_flash_to "Couldn't find that switch"
          should_redirect_to('home page') { root_url }
        end
      end
      
      context 'on GET to :new' do
        setup do
          get :new
        end
        should_respond_with(:success)
        should_render_template(:new)
        should_assign_to(:switch)
      end
      
      context 'on POST to :create' do
        context 'given valid parameters' do
          setup do
            post :create, :switch => Factory.attributes_for(:switch)
          end
          should_set_the_flash_to 'Successfully created switch.'
          should_redirect_to('the switch') { switch_url(assigns(:switch)) }
        end
        context 'given invalid parameters' do
          setup do
            post :create, :switch => { }
          end
          should_respond_with(:success)
          should_render_template(:new)
        end
      end
      
      context 'on GET to :edit' do
        setup do
          get :edit, :id => @switch.id
        end
        should_respond_with(:success)
        should_render_template(:edit)
        should_assign_to(:switch)
      end
      
      context 'on PUT to :update' do
        context 'given valid parameters' do
          setup do
            put :update, :id => @switch.id, :switch => Factory.attributes_for(:switch)
          end
          should_set_the_flash_to 'Successfully updated switch.'
          should_redirect_to('the switch') { switch_url(assigns(:switch)) }
          should_assign_to(:switch)
        end
        context 'given invalid parameters' do
          setup do
            put :update, :id => @switch.id, :switch => { :name => nil }
          end
          should_respond_with(:success)
          should_render_template(:edit)
          should_assign_to(:switch)
        end
      end

      context 'on DELETE to :destroy' do
        setup do
          delete :destroy, :id => @switch.id
        end
        should_set_the_flash_to 'Successfully destroyed switch.'
        should_redirect_to('the switch index') { switches_url }
      end
    end
    
    context 'with read-only privileges' do
      setup do
        @user.remove_role('admin')
        @user.add_role('executive')
        @switch = Factory(:switch)
      end
      
      context 'on GET to :index' do
        setup do
          get :index
        end
        should_respond_with :success
        should_render_template(:index)
        should_assign_to(:switches)
      end

      context 'on GET to :show' do
        context 'with existing switch ID' do
          setup do
             get :show, :id => @switch.id
          end
          should_respond_with :success
          should_render_template(:show)
          should_assign_to(:switch)
        end
        context 'with non-existent switch ID' do
          setup do
            get :show, :id => 0
          end
          should_set_the_flash_to "Couldn't find that switch"
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
            post :create, :switch => Factory.attributes_for(:switch)
          end
          should_redirect_to('home page') { root_url }
        end
        context 'given invalid parameters' do
          setup do
            post :create, :switch => { }
          end
          should_redirect_to('home page') { root_url }
        end
      end
      
      context 'on GET to :edit' do
        setup do
          get :edit, :id => @switch.id
        end
        should_redirect_to('home page') { root_url }
      end
      
      context 'on PUT to :update' do
        context 'given valid parameters' do
          setup do
            put :update, :id => @switch.id, :switch => Factory.attributes_for(:switch)
          end
          should_redirect_to('home page') { root_url }
        end
        context 'given invalid parameters' do
          setup do
            put :update, :id => @switch.id, :switch => { :name => nil }
          end
          should_redirect_to('home page') { root_url }
        end
      end

      context 'on DELETE to :destroy' do
        setup do
          delete :destroy, :id => @switch.id
        end
        should_redirect_to('home page') { root_url }
      end
    end
  end

end
