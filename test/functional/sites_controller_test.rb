require 'test_helper'

class SitesControllerTest < ActionController::TestCase
  context 'The public' do
    setup do
      @site = Factory(:site)
    end
    context 'on GET to :index' do
      setup do
        get :index
      end
      should_redirect_to('sign-in page') { sign_in_url }
    end
    
    context 'on GET to :show' do
      context 'with existing site ID' do
        setup do
          get :show, :id => @site.id
        end
        should_redirect_to('sign-in page') { sign_in_url }
      end
      context 'with non-existent site ID' do
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
        get :edit, :id => @site.id
      end
      should_redirect_to('sign-in page') { sign_in_url }
    end

    context 'on POST to :create' do
      setup do
        post :create, :site => Factory.attributes_for(:site)
      end
      should_redirect_to('sign-in page') { sign_in_url }
    end

    context 'on PUT to :update' do
      setup do
        put :update, :id => @site.id, :site => Factory.attributes_for(:site)
      end
      should_redirect_to('sign-in page') { sign_in_url }
    end

    context 'on DELETE to :destroy' do
      setup do
        delete :destroy, :id => @site.id
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
        @site = Factory(:site)
      end

      context 'on GET to :index' do
        setup do
          get :index
        end
        should_respond_with :success
        should_render_template(:index)
        should_assign_to(:sites)
      end
      
      context 'on GET to :show' do
        context 'with existing site ID' do
          setup do
             get :show, :id => @site.id
          end
          should_respond_with :success
          should_render_template(:show)
          should_assign_to(:site)
        end
        context 'with non-existant site ID' do
          setup do
            get :show, :id => 0
          end
          should_set_the_flash_to "Couldn't find that site"
          should_redirect_to('home page') { root_url }
        end
      end
      
      context 'on GET to :new' do
        setup do
          get :new
        end
        should_respond_with(:success)
        should_render_template(:new)
        should_assign_to(:site)
      end
      
      context 'on POST to :create' do
        context 'given valid parameters' do
          setup do
            post :create, :site => Factory.attributes_for(:site)
          end
          should_set_the_flash_to 'Successfully created site.'
          should_redirect_to('the site') { site_url(assigns(:site)) }
        end
        context 'given invalid parameters' do
          setup do
            post :create, :site => { }
          end
          should_respond_with(:success)
          should_render_template(:new)
        end
      end
      
      context 'on GET to :edit' do
        setup do
          get :edit, :id => @site.id
        end
        should_respond_with(:success)
        should_render_template(:edit)
        should_assign_to(:site)
      end
      
      context 'on PUT to :update' do
        context 'given valid parameters' do
          setup do
            put :update, :id => @site.id, :site => Factory.attributes_for(:site)
          end
          should_set_the_flash_to 'Successfully updated site.'
          should_redirect_to('the site') { site_url(assigns(:site)) }
          should_assign_to(:site)
        end
        context 'given invalid parameters' do
          setup do
            put :update, :id => @site.id, :site => { :name => nil }
          end
          should_respond_with(:success)
          should_render_template(:edit)
          should_assign_to(:site)
        end
      end

      context 'on DELETE to :destroy' do
        setup do
          delete :destroy, :id => @site.id
        end
        should_set_the_flash_to 'Successfully destroyed site.'
        should_redirect_to('the site index') { sites_url }
      end
    end
    
    context 'with read-only privileges' do
      setup do
        @user.remove_role('admin')
        @user.add_role('executive')
        @site = Factory(:site)
      end
      
      context 'on GET to :index' do
        setup do
          get :index
        end
        should_respond_with :success
        should_render_template(:index)
        should_assign_to(:sites)
      end

      context 'on GET to :show' do
        context 'with existing site ID' do
          setup do
             get :show, :id => @site.id
          end
          should_respond_with :success
          should_render_template(:show)
          should_assign_to(:site)
        end
        context 'with non-existent site ID' do
          setup do
            get :show, :id => 0
          end
          should_set_the_flash_to "Couldn't find that site"
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
            post :create, :site => Factory.attributes_for(:site)
          end
          should_redirect_to('home page') { root_url }
        end
        context 'given invalid parameters' do
          setup do
            post :create, :site => { }
          end
          should_redirect_to('home page') { root_url }
        end
      end
      
      context 'on GET to :edit' do
        setup do
          get :edit, :id => @site.id
        end
        should_redirect_to('home page') { root_url }
      end
      
      context 'on PUT to :update' do
        context 'given valid parameters' do
          setup do
            put :update, :id => @site.id, :site => Factory.attributes_for(:site)
          end
          should_redirect_to('home page') { root_url }
        end
        context 'given invalid parameters' do
          setup do
            put :update, :id => @site.id, :site => { :name => nil }
          end
          should_redirect_to('home page') { root_url }
        end
      end

      context 'on DELETE to :destroy' do
        setup do
          delete :destroy, :id => @site.id
        end
        should_redirect_to('home page') { root_url }
      end
    end
  end
end
