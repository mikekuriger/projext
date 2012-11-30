require 'test_helper'

class FarmsControllerTest < ActionController::TestCase
  context 'The public' do
    setup do
      @farm = Factory(:farm)
    end
    context 'on GET to :index' do
      setup do
        get :index
      end
      should_redirect_to('sign-in page') { sign_in_url }
    end
    
    context 'on GET to :show' do
      context 'with existing farm ID' do
        setup do
          get :show, :id => @farm.id
        end
        should_redirect_to('sign-in page') { sign_in_url }
      end
      context 'with non-existent farm ID' do
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
        get :edit, :id => @farm.id
      end
      should_redirect_to('sign-in page') { sign_in_url }
    end

    context 'on POST to :create' do
      setup do
        post :create, :farm => Factory.attributes_for(:farm)
      end
      should_redirect_to('sign-in page') { sign_in_url }
    end

    context 'on PUT to :update' do
      setup do
        put :update, :id => @farm.id, :farm => Factory.attributes_for(:farm)
      end
      should_redirect_to('sign-in page') { sign_in_url }
    end

    context 'on DELETE to :destroy' do
      setup do
        delete :destroy, :id => @farm.id
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
        @farm = Factory(:farm)
      end

      context 'on GET to :index' do
        setup do
          get :index
        end
        should_respond_with :success
        should_render_template(:index)
        should_assign_to(:farms)
      end
      
      context 'on GET to :show' do
        context 'with existing farm ID' do
          setup do
             get :show, :id => @farm.id
          end
          should_respond_with :success
          should_render_template(:show)
          should_assign_to(:farm)
        end
        context 'with non-existant farm ID' do
          setup do
            get :show, :id => 0
          end
          should_set_the_flash_to "Couldn't find that farm"
          should_redirect_to('home page') { root_url }
        end
      end
      
      context 'on GET to :new' do
        setup do
          get :new
        end
        should_respond_with(:success)
        should_render_template(:new)
        should_assign_to(:farm)
      end
      
      context 'on POST to :create' do
        context 'given valid parameters' do
          setup do
            post :create, :farm => Factory.attributes_for(:farm)
          end
          should_set_the_flash_to 'Successfully created farm.'
          should_redirect_to('the farm') { farm_url(assigns(:farm)) }
        end
        context 'given invalid parameters' do
          setup do
            post :create, :farm => { }
          end
          should_respond_with(:success)
          should_render_template(:new)
        end
      end
      
      context 'on GET to :edit' do
        setup do
          get :edit, :id => @farm.id
        end
        should_respond_with(:success)
        should_render_template(:edit)
        should_assign_to(:farm)
      end
      
      context 'on PUT to :update' do
        context 'given valid parameters' do
          setup do
            put :update, :id => @farm.id, :farm => Factory.attributes_for(:farm)
          end
          should_set_the_flash_to 'Successfully updated farm.'
          should_redirect_to('the farm') { farm_url(assigns(:farm)) }
          should_assign_to(:farm)
        end
        context 'given invalid parameters' do
          setup do
            put :update, :id => @farm.id, :farm => { :name => nil }
          end
          should_respond_with(:success)
          should_render_template(:edit)
          should_assign_to(:farm)
        end
      end

      context 'on DELETE to :destroy' do
        setup do
          delete :destroy, :id => @farm.id
        end
        should_set_the_flash_to 'Successfully destroyed farm.'
        should_redirect_to('the farm index') { farms_url }
      end
    end
    
    context 'with read-only privileges' do
      setup do
        @user.remove_role('admin')
        @user.add_role('executive')
        @farm = Factory(:farm)
      end
      
      context 'on GET to :index' do
        setup do
          get :index
        end
        should_respond_with :success
        should_render_template(:index)
        should_assign_to(:farms)
      end

      context 'on GET to :show' do
        context 'with existing farm ID' do
          setup do
             get :show, :id => @farm.id
          end
          should_respond_with :success
          should_render_template(:show)
          should_assign_to(:farm)
        end
        context 'with non-existent farm ID' do
          setup do
            get :show, :id => 0
          end
          should_set_the_flash_to "Couldn't find that farm"
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
            post :create, :farm => Factory.attributes_for(:farm)
          end
          should_redirect_to('home page') { root_url }
        end
        context 'given invalid parameters' do
          setup do
            post :create, :farm => { }
          end
          should_redirect_to('home page') { root_url }
        end
      end
      
      context 'on GET to :edit' do
        setup do
          get :edit, :id => @farm.id
        end
        should_redirect_to('home page') { root_url }
      end
      
      context 'on PUT to :update' do
        context 'given valid parameters' do
          setup do
            put :update, :id => @farm.id, :farm => Factory.attributes_for(:farm)
          end
          should_redirect_to('home page') { root_url }
        end
        context 'given invalid parameters' do
          setup do
            put :update, :id => @farm.id, :farm => { :name => nil }
          end
          should_redirect_to('home page') { root_url }
        end
      end

      context 'on DELETE to :destroy' do
        setup do
          delete :destroy, :id => @farm.id
        end
        should_redirect_to('home page') { root_url }
      end
    end
  end
end
