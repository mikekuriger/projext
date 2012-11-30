require 'test_helper'

class AppsControllerTest < ActionController::TestCase
  context 'The public' do
    setup do
      @app = Factory(:app)
    end
    context 'on GET to :index' do
      setup do
        get :index
      end
      should_redirect_to('sign-in page') { sign_in_url }
    end
    
    context 'on GET to :show' do
      context 'with existing app ID' do
        setup do
          get :show, :id => @app.id
        end
        should_redirect_to('sign-in page') { sign_in_url }
      end
      context 'with non-existent app ID' do
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
        get :edit, :id => @app.id
      end
      should_redirect_to('sign-in page') { sign_in_url }
    end

    context 'on POST to :create' do
      setup do
        post :create, :app => Factory.attributes_for(:app)
      end
      should_redirect_to('sign-in page') { sign_in_url }
    end

    context 'on PUT to :update' do
      setup do
        put :update, :id => @app.id, :app => Factory.attributes_for(:app)
      end
      should_redirect_to('sign-in page') { sign_in_url }
    end

    context 'on DELETE to :destroy' do
      setup do
        delete :destroy, :id => @app.id
      end
      should_redirect_to('sign-in page') { sign_in_url }
    end
    
  end
  
  context 'A signed-in user' do
    setup do
      @user = Factory(:email_confirmed_user)
      @controller.current_user = @user
    end
    
    context 'with admin privileges' do
      setup do
        @user.add_role('admin')
        @app = Factory(:app)
      end

      context 'on GET to :index' do
        setup do
          get :index
        end
        should_respond_with :success
        should_render_template(:index)
        should_assign_to(:apps)
      end
      
      context 'on GET to :show' do
        context 'with existing app ID' do
          setup do
             get :show, :id => @app.id
          end
          should_respond_with :success
          should_render_template(:show)
          should_assign_to(:app)
        end
        context 'with non-existant app ID' do
          setup do
            get :show, :id => 0
          end
          should_set_the_flash_to "Couldn't find that app"
          should_redirect_to('home page') { root_url }
        end
      end
      
      context 'on GET to :new' do
        setup do
          get :new
        end
        should_respond_with(:success)
        should_render_template(:new)
        should_assign_to(:app)
      end
      
      context 'on POST to :create' do
        context 'given valid parameters' do
          setup do
            post :create, :app => Factory.attributes_for(:app)
          end
          should_set_the_flash_to 'Successfully created app.'
          should_redirect_to('the app') { app_url(assigns(:app)) }
        end
        context 'given invalid parameters' do
          setup do
            post :create, :app => { }
          end
          should_respond_with(:success)
          should_render_template(:new)
        end
      end
      
      context 'on GET to :edit' do
        setup do
          get :edit, :id => @app.id
        end
        should_respond_with(:success)
        should_render_template(:edit)
        should_assign_to(:app)
      end
      
      context 'on PUT to :update' do
        context 'given valid parameters' do
          setup do
            put :update, :id => @app.id, :app => Factory.attributes_for(:app)
          end
          should_set_the_flash_to 'Successfully updated app.'
          should_redirect_to('the app') { app_url(assigns(:app)) }
          should_assign_to(:app)
        end
        context 'given invalid parameters' do
          setup do
            put :update, :id => @app.id, :app => { :name => nil }
          end
          should_respond_with(:success)
          should_render_template(:edit)
          should_assign_to(:app)
        end
      end

      context 'on DELETE to :destroy' do
        setup do
          delete :destroy, :id => @app.id
        end
        should_set_the_flash_to 'Successfully destroyed app.'
        should_redirect_to('the app index') { apps_url }
      end
    end
    
    context 'with read-only privileges' do
      setup do
        @user.remove_role('admin')
        @user.add_role('executive')
        @app = Factory(:app)
      end
      
      context 'on GET to :index' do
        setup do
          get :index
        end
        should_respond_with :success
        should_render_template(:index)
        should_assign_to(:apps)
      end

      context 'on GET to :show' do
        context 'with existing app ID' do
          setup do
             get :show, :id => @app.id
          end
          should_respond_with :success
          should_render_template(:show)
          should_assign_to(:app)
        end
        context 'with non-existent app ID' do
          setup do
            get :show, :id => 0
          end
          should_set_the_flash_to "Couldn't find that app"
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
            post :create, :app => Factory.attributes_for(:app)
          end
          should_redirect_to('home page') { root_url }
        end
        context 'given invalid parameters' do
          setup do
            post :create, :app => { }
          end
          should_redirect_to('home page') { root_url }
        end
      end
      
      context 'on GET to :edit' do
        setup do
          get :edit, :id => @app.id
        end
        should_redirect_to('home page') { root_url }
      end
      
      context 'on PUT to :update' do
        context 'given valid parameters' do
          setup do
            put :update, :id => @app.id, :app => Factory.attributes_for(:app)
          end
          should_redirect_to('home page') { root_url }
        end
        context 'given invalid parameters' do
          setup do
            put :update, :id => @app.id, :app => { :name => nil }
          end
          should_redirect_to('home page') { root_url }
        end
      end

      context 'on DELETE to :destroy' do
        setup do
          delete :destroy, :id => @app.id
        end
        should_redirect_to('home page') { root_url }
      end
    end
  end

end
