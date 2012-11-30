require 'test_helper'

class FunctionsControllerTest < ActionController::TestCase
  context 'The public' do
    setup do
      @function = Factory(:function)
    end
    context 'on GET to :index' do
      setup do
        get :index
      end
      should_redirect_to('sign-in page') { sign_in_url }
    end
    
    context 'on GET to :show' do
      context 'with existing function ID' do
        setup do
          get :show, :id => @function.id
        end
        should_redirect_to('sign-in page') { sign_in_url }
      end
      context 'with non-existent function ID' do
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
        get :edit, :id => @function.id
      end
      should_redirect_to('sign-in page') { sign_in_url }
    end

    context 'on POST to :create' do
      setup do
        post :create, :function => Factory.attributes_for(:function)
      end
      should_redirect_to('sign-in page') { sign_in_url }
    end

    context 'on PUT to :update' do
      setup do
        put :update, :id => @function.id, :function => Factory.attributes_for(:function)
      end
      should_redirect_to('sign-in page') { sign_in_url }
    end

    context 'on DELETE to :destroy' do
      setup do
        delete :destroy, :id => @function.id
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
        @function = Factory(:function)
      end

      context 'on GET to :index' do
        setup do
          get :index
        end
        should_respond_with :success
        should_render_template(:index)
        should_assign_to(:functions)
      end
      
      context 'on GET to :show' do
        context 'with existing function ID' do
          setup do
             get :show, :id => @function.id
          end
          should_respond_with :success
          should_render_template(:show)
          should_assign_to(:function)
        end
        context 'with non-existant function ID' do
          setup do
            get :show, :id => 0
          end
          should_set_the_flash_to "Couldn't find that function"
          should_redirect_to('home page') { root_url }
        end
      end
      
      context 'on GET to :new' do
        setup do
          get :new
        end
        should_respond_with(:success)
        should_render_template(:new)
        should_assign_to(:function)
      end
      
      context 'on POST to :create' do
        context 'given valid parameters' do
          setup do
            post :create, :function => Factory.attributes_for(:function)
          end
          should_set_the_flash_to 'Successfully created function.'
          should_redirect_to('the function') { function_url(assigns(:function)) }
        end
        context 'given invalid parameters' do
          setup do
            post :create, :function => { }
          end
          should_respond_with(:success)
          should_render_template(:new)
        end
      end
      
      context 'on GET to :edit' do
        setup do
          get :edit, :id => @function.id
        end
        should_respond_with(:success)
        should_render_template(:edit)
        should_assign_to(:function)
      end
      
      context 'on PUT to :update' do
        context 'given valid parameters' do
          setup do
            put :update, :id => @function.id, :function => Factory.attributes_for(:function)
          end
          should_set_the_flash_to 'Successfully updated function.'
          should_redirect_to('the function') { function_url(assigns(:function)) }
          should_assign_to(:function)
        end
        context 'given invalid parameters' do
          setup do
            put :update, :id => @function.id, :function => { :name => nil }
          end
          should_respond_with(:success)
          should_render_template(:edit)
          should_assign_to(:function)
        end
      end

      context 'on DELETE to :destroy' do
        setup do
          delete :destroy, :id => @function.id
        end
        should_set_the_flash_to 'Successfully destroyed function.'
        should_redirect_to('the function index') { functions_url }
      end
    end
    
    context 'with read-only privileges' do
      setup do
        @user.remove_role('admin')
        @user.add_role('executive')
        @function = Factory(:function)
      end
      
      context 'on GET to :index' do
        setup do
          get :index
        end
        should_respond_with :success
        should_render_template(:index)
        should_assign_to(:functions)
      end

      context 'on GET to :show' do
        context 'with existing function ID' do
          setup do
             get :show, :id => @function.id
          end
          should_respond_with :success
          should_render_template(:show)
          should_assign_to(:function)
        end
        context 'with non-existent function ID' do
          setup do
            get :show, :id => 0
          end
          should_set_the_flash_to "Couldn't find that function"
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
            post :create, :function => Factory.attributes_for(:function)
          end
          should_redirect_to('home page') { root_url }
        end
        context 'given invalid parameters' do
          setup do
            post :create, :function => { }
          end
          should_redirect_to('home page') { root_url }
        end
      end
      
      context 'on GET to :edit' do
        setup do
          get :edit, :id => @function.id
        end
        should_redirect_to('home page') { root_url }
      end
      
      context 'on PUT to :update' do
        context 'given valid parameters' do
          setup do
            put :update, :id => @function.id, :function => Factory.attributes_for(:function)
          end
          should_redirect_to('home page') { root_url }
        end
        context 'given invalid parameters' do
          setup do
            put :update, :id => @function.id, :function => { :name => nil }
          end
          should_redirect_to('home page') { root_url }
        end
      end

      context 'on DELETE to :destroy' do
        setup do
          delete :destroy, :id => @function.id
        end
        should_redirect_to('home page') { root_url }
      end
    end
  end
end
