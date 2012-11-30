require 'test_helper'

class BuildingsControllerTest < ActionController::TestCase
  context 'The public' do
    setup do
      @building = Factory(:building)
    end
    context 'on GET to :index' do
      setup do
        get :index
      end
      should_redirect_to('sign-in page') { sign_in_url }
    end
    
    context 'on GET to :show' do
      context 'with existing building ID' do
        setup do
          get :show, :id => @building.id
        end
        should_redirect_to('sign-in page') { sign_in_url }
      end
      context 'with non-existent building ID' do
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
        get :edit, :id => @building.id
      end
      should_redirect_to('sign-in page') { sign_in_url }
    end

    context 'on POST to :create' do
      setup do
        post :create, :building => Factory.attributes_for(:building)
      end
      should_redirect_to('sign-in page') { sign_in_url }
    end

    context 'on PUT to :update' do
      setup do
        put :update, :id => @building.id, :building => Factory.attributes_for(:building)
      end
      should_redirect_to('sign-in page') { sign_in_url }
    end

    context 'on DELETE to :destroy' do
      setup do
        delete :destroy, :id => @building.id
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
        @building = Factory(:building)
      end

      context 'on GET to :index' do
        setup do
          get :index
        end
        should_respond_with :success
        should_render_template(:index)
        should_assign_to(:buildings)
      end
      
      context 'on GET to :show' do
        context 'with existing building ID' do
          setup do
             get :show, :id => @building.id
          end
          should_respond_with :success
          should_render_template(:show)
          should_assign_to(:building)
        end
        context 'with non-existant building ID' do
          setup do
            get :show, :id => 0
          end
          should_set_the_flash_to "Couldn't find that building"
          should_redirect_to('home page') { root_url }
        end
      end
      
      context 'on GET to :new' do
        setup do
          get :new
        end
        should_respond_with(:success)
        should_render_template(:new)
        should_assign_to(:building)
      end
      
      context 'on POST to :create' do
        context 'given valid parameters' do
          setup do
            post :create, :building => Factory.attributes_for(:building)
          end
          should_set_the_flash_to 'Successfully created building.'
          should_redirect_to('the building') { building_url(assigns(:building)) }
        end
        context 'given invalid parameters' do
          setup do
            post :create, :building => { }
          end
          should_respond_with(:success)
          should_render_template(:new)
        end
      end
      
      context 'on GET to :edit' do
        setup do
          get :edit, :id => @building.id
        end
        should_respond_with(:success)
        should_render_template(:edit)
        should_assign_to(:building)
      end
      
      context 'on PUT to :update' do
        context 'given valid parameters' do
          setup do
            put :update, :id => @building.id, :building => Factory.attributes_for(:building)
          end
          should_set_the_flash_to 'Successfully updated building.'
          should_redirect_to('the building') { building_url(assigns(:building)) }
          should_assign_to(:building)
        end
        context 'given invalid parameters' do
          setup do
            put :update, :id => @building.id, :building => { :name => nil }
          end
          should_respond_with(:success)
          should_render_template(:edit)
          should_assign_to(:building)
        end
      end

      context 'on DELETE to :destroy' do
        setup do
          delete :destroy, :id => @building.id
        end
        should_set_the_flash_to 'Successfully destroyed building.'
        should_redirect_to('the building index') { buildings_url }
      end
    end
    
    context 'with read-only privileges' do
      setup do
        @user.remove_role('admin')
        @user.add_role('executive')
        @building = Factory(:building)
      end
      
      context 'on GET to :index' do
        setup do
          get :index
        end
        should_respond_with :success
        should_render_template(:index)
        should_assign_to(:buildings)
      end

      context 'on GET to :show' do
        context 'with existing building ID' do
          setup do
             get :show, :id => @building.id
          end
          should_respond_with :success
          should_render_template(:show)
          should_assign_to(:building)
        end
        context 'with non-existent building ID' do
          setup do
            get :show, :id => 0
          end
          should_set_the_flash_to "Couldn't find that building"
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
            post :create, :building => Factory.attributes_for(:building)
          end
          should_redirect_to('home page') { root_url }
        end
        context 'given invalid parameters' do
          setup do
            post :create, :building => { }
          end
          should_redirect_to('home page') { root_url }
        end
      end
      
      context 'on GET to :edit' do
        setup do
          get :edit, :id => @building.id
        end
        should_redirect_to('home page') { root_url }
      end
      
      context 'on PUT to :update' do
        context 'given valid parameters' do
          setup do
            put :update, :id => @building.id, :building => Factory.attributes_for(:building)
          end
          should_redirect_to('home page') { root_url }
        end
        context 'given invalid parameters' do
          setup do
            put :update, :id => @building.id, :building => { :name => nil }
          end
          should_redirect_to('home page') { root_url }
        end
      end

      context 'on DELETE to :destroy' do
        setup do
          delete :destroy, :id => @building.id
        end
        should_redirect_to('home page') { root_url }
      end
    end
  end
end
