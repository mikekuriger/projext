require 'test_helper'

class StorageArraysControllerTest < ActionController::TestCase
  context 'The public' do
    setup do
      @storage_array = Factory(:storage_array)
    end
    context 'on GET to :index' do
      setup do
        get :index
      end
      should_redirect_to('sign-in page') { sign_in_url }
    end
    
    context 'on GET to :show' do
      context 'with existing storage array ID' do
        setup do
          get :show, :id => @storage_array.id
        end
        should_redirect_to('sign-in page') { sign_in_url }
      end
      context 'with non-existent storage array ID' do
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
        get :edit, :id => @storage_array.id
      end
      should_redirect_to('sign-in page') { sign_in_url }
    end

    context 'on POST to :create' do
      setup do
        post :create, :storage_array => Factory.attributes_for(:storage_array)
      end
      should_redirect_to('sign-in page') { sign_in_url }
    end

    context 'on PUT to :update' do
      setup do
        put :update, :id => @storage_array.id, :storage_array => Factory.attributes_for(:storage_array)
      end
      should_redirect_to('sign-in page') { sign_in_url }
    end

    context 'on DELETE to :destroy' do
      setup do
        delete :destroy, :id => @storage_array.id
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
        @storage_array = Factory(:storage_array)
      end

      context 'on GET to :index' do
        setup do
          get :index
        end
        should_respond_with :success
        should_render_template(:index)
        should_assign_to(:storage_arrays)
      end
      
      context 'on GET to :show' do
        context 'with existing storage array ID' do
          setup do
             get :show, :id => @storage_array.id
          end
          should_respond_with :success
          should_render_template(:show)
          should_assign_to(:storage_array)
        end
        context 'with non-existant storage array ID' do
          setup do
            get :show, :id => 0
          end
          should_set_the_flash_to "Couldn't find that storage array"
          should_redirect_to('home page') { root_url }
        end
      end
      
      context 'on GET to :new' do
        setup do
          get :new
        end
        should_respond_with(:success)
        should_render_template(:new)
        should_assign_to(:storage_array)
      end
      
      context 'on POST to :create' do
        context 'given valid parameters' do
          setup do
            post :create, :storage_array => Factory.attributes_for(:storage_array)
          end
          should_set_the_flash_to 'Successfully created storage array.'
          should_redirect_to('the storage array') { storage_array_url(assigns(:storage_array)) }
        end
        context 'given invalid parameters' do
          setup do
            post :create, :storage_array => { }
          end
          should_respond_with(:success)
          should_render_template(:new)
        end
      end
      
      context 'on GET to :edit' do
        setup do
          get :edit, :id => @storage_array.id
        end
        should_respond_with(:success)
        should_render_template(:edit)
        should_assign_to(:storage_array)
      end
      
      context 'on PUT to :update' do
        context 'given valid parameters' do
          setup do
            put :update, :id => @storage_array.id, :storage_array => Factory.attributes_for(:storage_array)
          end
          should_set_the_flash_to 'Successfully updated storage array.'
          should_redirect_to('the storage array') { storage_array_url(assigns(:storage_array)) }
          should_assign_to(:storage_array)
        end
        context 'given invalid parameters' do
          setup do
            put :update, :id => @storage_array.id, :storage_array => { :name => nil }
          end
          should_respond_with(:success)
          should_render_template(:edit)
          should_assign_to(:storage_array)
        end
      end

      context 'on DELETE to :destroy' do
        setup do
          delete :destroy, :id => @storage_array.id
        end
        should_set_the_flash_to 'Successfully destroyed storage array.'
        should_redirect_to('the storage array index') { storage_arrays_url }
      end
    end
    
    context 'with read-only privileges' do
      setup do
        @user.remove_role('admin')
        @user.add_role('executive')
        @storage_array = Factory(:storage_array)
      end
      
      context 'on GET to :index' do
        setup do
          get :index
        end
        should_respond_with :success
        should_render_template(:index)
        should_assign_to(:storage_arrays)
      end

      context 'on GET to :show' do
        context 'with existing storage array ID' do
          setup do
             get :show, :id => @storage_array.id
          end
          should_respond_with :success
          should_render_template(:show)
          should_assign_to(:storage_array)
        end
        context 'with non-existent storage array ID' do
          setup do
            get :show, :id => 0
          end
          should_set_the_flash_to "Couldn't find that storage array"
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
            post :create, :storage_array => Factory.attributes_for(:storage_array)
          end
          should_redirect_to('home page') { root_url }
        end
        context 'given invalid parameters' do
          setup do
            post :create, :storage_array => { }
          end
          should_redirect_to('home page') { root_url }
        end
      end
      
      context 'on GET to :edit' do
        setup do
          get :edit, :id => @storage_array.id
        end
        should_redirect_to('home page') { root_url }
      end
      
      context 'on PUT to :update' do
        context 'given valid parameters' do
          setup do
            put :update, :id => @storage_array.id, :storage_array => Factory.attributes_for(:storage_array)
          end
          should_redirect_to('home page') { root_url }
        end
        context 'given invalid parameters' do
          setup do
            put :update, :id => @storage_array.id, :storage_array => { :name => nil }
          end
          should_redirect_to('home page') { root_url }
        end
      end

      context 'on DELETE to :destroy' do
        setup do
          delete :destroy, :id => @storage_array.id
        end
        should_redirect_to('home page') { root_url }
      end
    end
  end

end
