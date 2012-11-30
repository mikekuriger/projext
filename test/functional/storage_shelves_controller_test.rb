require 'test_helper'

class StorageShelvesControllerTest < ActionController::TestCase
  context 'The public' do
    setup do
      @storage_shelf = Factory(:storage_shelf)
    end
    context 'on GET to :index' do
      setup do
        get :index
      end
      should_redirect_to('sign-in page') { sign_in_url }
    end
    
    context 'on GET to :show' do
      context 'with existing storage shelf ID' do
        setup do
          get :show, :id => @storage_shelf.id
        end
        should_redirect_to('sign-in page') { sign_in_url }
      end
      context 'with non-existent storage shelf ID' do
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
        get :edit, :id => @storage_shelf.id
      end
      should_redirect_to('sign-in page') { sign_in_url }
    end

    context 'on POST to :create' do
      setup do
        post :create, :storage_shelf => Factory.attributes_for(:storage_shelf)
      end
      should_redirect_to('sign-in page') { sign_in_url }
    end

    context 'on PUT to :update' do
      setup do
        put :update, :id => @storage_shelf.id, :storage_shelf => Factory.attributes_for(:storage_shelf)
      end
      should_redirect_to('sign-in page') { sign_in_url }
    end

    context 'on DELETE to :destroy' do
      setup do
        delete :destroy, :id => @storage_shelf.id
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
        @storage_shelf = Factory(:storage_shelf)
      end

      context 'on GET to :index' do
        setup do
          get :index
        end
        should_respond_with :success
        should_render_template(:index)
        should_assign_to(:storage_shelves)
      end
      
      context 'on GET to :show' do
        context 'with existing storage shelf ID' do
          setup do
             get :show, :id => @storage_shelf.id
          end
          should_respond_with :success
          should_render_template(:show)
          should_assign_to(:storage_shelf)
        end
        context 'with non-existant storage shelf ID' do
          setup do
            get :show, :id => 0
          end
          should_set_the_flash_to "Couldn't find that storage shelf"
          should_redirect_to('home page') { root_url }
        end
      end
      
      context 'on GET to :new' do
        setup do
          get :new
        end
        should_respond_with(:success)
        should_render_template(:new)
        should_assign_to(:storage_shelf)
      end
      
      context 'on POST to :create' do
        context 'given valid parameters' do
          setup do
            post :create, :storage_shelf => Factory.attributes_for(:storage_shelf)
          end
          should_set_the_flash_to 'Successfully created storage shelf.'
          should_redirect_to('the storage shelf') { storage_shelf_url(assigns(:storage_shelf)) }
        end
        context 'given invalid parameters' do
          setup do
            post :create, :storage_shelf => { }
          end
          should_respond_with(:success)
          should_render_template(:new)
        end
      end
      
      context 'on GET to :edit' do
        setup do
          get :edit, :id => @storage_shelf.id
        end
        should_respond_with(:success)
        should_render_template(:edit)
        should_assign_to(:storage_shelf)
      end
      
      context 'on PUT to :update' do
        context 'given valid parameters' do
          setup do
            put :update, :id => @storage_shelf.id, :storage_shelf => Factory.attributes_for(:storage_shelf)
          end
          should_set_the_flash_to 'Successfully updated storage shelf.'
          should_redirect_to('the storage shelf') { storage_shelf_url(assigns(:storage_shelf)) }
          should_assign_to(:storage_shelf)
        end
        context 'given invalid parameters' do
          setup do
            put :update, :id => @storage_shelf.id, :storage_shelf => { :name => nil }
          end
          should_respond_with(:success)
          should_render_template(:edit)
          should_assign_to(:storage_shelf)
        end
      end

      context 'on DELETE to :destroy' do
        setup do
          delete :destroy, :id => @storage_shelf.id
        end
        should_set_the_flash_to 'Successfully destroyed storage shelf.'
        should_redirect_to('the storage shelf index') { storage_shelves_url }
      end
    end
    
    context 'with read-only privileges' do
      setup do
        @user.remove_role('admin')
        @user.add_role('executive')
        @storage_shelf = Factory(:storage_shelf)
      end
      
      context 'on GET to :index' do
        setup do
          get :index
        end
        should_respond_with :success
        should_render_template(:index)
        should_assign_to(:storage_shelves)
      end

      context 'on GET to :show' do
        context 'with existing storage_shelf ID' do
          setup do
             get :show, :id => @storage_shelf.id
          end
          should_respond_with :success
          should_render_template(:show)
          should_assign_to(:storage_shelf)
        end
        context 'with non-existent storage shelf ID' do
          setup do
            get :show, :id => 0
          end
          should_set_the_flash_to "Couldn't find that storage shelf"
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
            post :create, :storage_shelf => Factory.attributes_for(:storage_shelf)
          end
          should_redirect_to('home page') { root_url }
        end
        context 'given invalid parameters' do
          setup do
            post :create, :storage_shelf => { }
          end
          should_redirect_to('home page') { root_url }
        end
      end
      
      context 'on GET to :edit' do
        setup do
          get :edit, :id => @storage_shelf.id
        end
        should_redirect_to('home page') { root_url }
      end
      
      context 'on PUT to :update' do
        context 'given valid parameters' do
          setup do
            put :update, :id => @storage_shelf.id, :storage_shelf => Factory.attributes_for(:storage_shelf)
          end
          should_redirect_to('home page') { root_url }
        end
        context 'given invalid parameters' do
          setup do
            put :update, :id => @storage_shelf.id, :storage_shelf => { :name => nil }
          end
          should_redirect_to('home page') { root_url }
        end
      end

      context 'on DELETE to :destroy' do
        setup do
          delete :destroy, :id => @storage_shelf.id
        end
        should_redirect_to('home page') { root_url }
      end
    end
  end

end
