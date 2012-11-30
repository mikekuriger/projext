require 'test_helper'

class StorageHeadsControllerTest < ActionController::TestCase
  context 'The public' do
    setup do
      @storage_head = Factory(:storage_head)
    end
    context 'on GET to :index' do
      setup do
        get :index
      end
      should_redirect_to('sign-in page') { sign_in_url }
    end
    
    context 'on GET to :show' do
      context 'with existing storage head ID' do
        setup do
          get :show, :id => @storage_head.id
        end
        should_redirect_to('sign-in page') { sign_in_url }
      end
      context 'with non-existent storage head ID' do
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
        get :edit, :id => @storage_head.id
      end
      should_redirect_to('sign-in page') { sign_in_url }
    end

    context 'on POST to :create' do
      setup do
        post :create, :storage_head => Factory.attributes_for(:storage_head)
      end
      should_redirect_to('sign-in page') { sign_in_url }
    end

    context 'on PUT to :update' do
      setup do
        put :update, :id => @storage_head.id, :storage_head => Factory.attributes_for(:storage_head)
      end
      should_redirect_to('sign-in page') { sign_in_url }
    end

    context 'on DELETE to :destroy' do
      setup do
        delete :destroy, :id => @storage_head.id
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
        @storage_head = Factory(:storage_head)
      end

      context 'on GET to :index' do
        setup do
          get :index
        end
        should_respond_with :success
        should_render_template(:index)
        should_assign_to(:storage_heads)
      end
      
      context 'on GET to :show' do
        context 'with existing storage head ID' do
          setup do
             get :show, :id => @storage_head.id
          end
          should_respond_with :success
          should_render_template(:show)
          should_assign_to(:storage_head)
        end
        context 'with non-existant storage head ID' do
          setup do
            get :show, :id => 0
          end
          should_set_the_flash_to "Couldn't find that storage head"
          should_redirect_to('home page') { root_url }
        end
      end
      
      context 'on GET to :new' do
        setup do
          get :new
        end
        should_respond_with(:success)
        should_render_template(:new)
        should_assign_to(:storage_head)
      end
      
      context 'on POST to :create' do
        context 'given valid parameters' do
          setup do
            post :create, :storage_head => Factory.attributes_for(:storage_head)
          end
          should_set_the_flash_to 'Successfully created storage head.'
          should_redirect_to('the storage head') { storage_head_url(assigns(:storage_head)) }
        end
        context 'given invalid parameters' do
          setup do
            post :create, :storage_head => { }
          end
          should_respond_with(:success)
          should_render_template(:new)
        end
      end
      
      context 'on GET to :edit' do
        setup do
          get :edit, :id => @storage_head.id
        end
        should_respond_with(:success)
        should_render_template(:edit)
        should_assign_to(:storage_head)
      end
      
      context 'on PUT to :update' do
        context 'given valid parameters' do
          setup do
            put :update, :id => @storage_head.id, :storage_head => Factory.attributes_for(:storage_head)
          end
          should_set_the_flash_to 'Successfully updated storage head.'
          should_redirect_to('the storage head') { storage_head_url(assigns(:storage_head)) }
          should_assign_to(:storage_head)
        end
        context 'given invalid parameters' do
          setup do
            put :update, :id => @storage_head.id, :storage_head => { :name => nil }
          end
          should_respond_with(:success)
          should_render_template(:edit)
          should_assign_to(:storage_head)
        end
      end

      context 'on DELETE to :destroy' do
        setup do
          delete :destroy, :id => @storage_head.id
        end
        should_set_the_flash_to 'Successfully destroyed storage head.'
        should_redirect_to('the storage head index') { storage_heads_url }
      end
    end
    
    context 'with read-only privileges' do
      setup do
        @user.remove_role('admin')
        @user.add_role('executive')
        @storage_head = Factory(:storage_head)
      end
      
      context 'on GET to :index' do
        setup do
          get :index
        end
        should_respond_with :success
        should_render_template(:index)
        should_assign_to(:storage_heads)
      end

      context 'on GET to :show' do
        context 'with existing storage head ID' do
          setup do
             get :show, :id => @storage_head.id
          end
          should_respond_with :success
          should_render_template(:show)
          should_assign_to(:storage_head)
        end
        context 'with non-existent storage head ID' do
          setup do
            get :show, :id => 0
          end
          should_set_the_flash_to "Couldn't find that storage head"
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
            post :create, :storage_head => Factory.attributes_for(:storage_head)
          end
          should_redirect_to('home page') { root_url }
        end
        context 'given invalid parameters' do
          setup do
            post :create, :storage_head => { }
          end
          should_redirect_to('home page') { root_url }
        end
      end
      
      context 'on GET to :edit' do
        setup do
          get :edit, :id => @storage_head.id
        end
        should_redirect_to('home page') { root_url }
      end
      
      context 'on PUT to :update' do
        context 'given valid parameters' do
          setup do
            put :update, :id => @storage_head.id, :storage_head => Factory.attributes_for(:storage_head)
          end
          should_redirect_to('home page') { root_url }
        end
        context 'given invalid parameters' do
          setup do
            put :update, :id => @storage_head.id, :storage_head => { :name => nil }
          end
          should_redirect_to('home page') { root_url }
        end
      end

      context 'on DELETE to :destroy' do
        setup do
          delete :destroy, :id => @storage_head.id
        end
        should_redirect_to('home page') { root_url }
      end
    end
  end

end
