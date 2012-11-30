require 'test_helper'

class ParameterNamesControllerTest < ActionController::TestCase
  context 'The public' do
    setup do
      @parameter_name = Factory(:parameter_name)
    end
    context 'on GET to :index' do
      setup do
        get :index
      end
      should_redirect_to('sign-in page') { sign_in_url }
    end
    
    context 'on GET to :show' do
      context 'with existing parameter ID' do
        setup do
          get :show, :id => @parameter_name.id
        end
        should_redirect_to('sign-in page') { sign_in_url }
      end
      context 'with non-existent parameter ID' do
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
        get :edit, :id => @parameter_name.id
      end
      should_redirect_to('sign-in page') { sign_in_url }
    end

    context 'on POST to :create' do
      setup do
        post :create, :parameter_name => Factory.attributes_for(:parameter_name)
      end
      should_redirect_to('sign-in page') { sign_in_url }
    end

    context 'on PUT to :update' do
      setup do
        put :update, :id => @parameter_name.id, :parameter_name => Factory.attributes_for(:parameter_name)
      end
      should_redirect_to('sign-in page') { sign_in_url }
    end

    context 'on DELETE to :destroy' do
      setup do
        delete :destroy, :id => @parameter_name.id
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
        @parameter_name = Factory(:parameter_name)
      end

      context 'on GET to :index' do
        setup do
          get :index
        end
        should_respond_with :success
        should_render_template(:index)
        should_assign_to(:parameter_names)
      end
      
      context 'on GET to :show' do
        context 'with existing parameter ID' do
          setup do
             get :show, :id => @parameter_name.id
          end
          should_respond_with :success
          should_render_template(:show)
          should_assign_to(:parameter_name)
        end
        context 'with non-existant parameter ID' do
          setup do
            get :show, :id => 0
          end
          should_set_the_flash_to "Couldn't find that parameter name"
          should_redirect_to('home page') { root_url }
        end
      end
      
      context 'on GET to :new' do
        setup do
          get :new
        end
        should_respond_with(:success)
        should_render_template(:new)
        should_assign_to(:parameter_name)
      end
      
      context 'on POST to :create' do
        context 'given valid parameters' do
          setup do
            post :create, :parameter_name => Factory.attributes_for(:parameter_name)
          end
          should_set_the_flash_to 'Successfully created parameter name.'
          should_redirect_to('the parameter') { parameter_name_url(assigns(:parameter_name)) }
        end
        context 'given invalid parameters' do
          setup do
            post :create, :parameter_name => { }
          end
          should_respond_with(:success)
          should_render_template(:new)
        end
      end
      
      context 'on GET to :edit' do
        setup do
          get :edit, :id => @parameter_name.id
        end
        should_respond_with(:success)
        should_render_template(:edit)
        should_assign_to(:parameter_name)
      end
      
      context 'on PUT to :update' do
        context 'given valid parameters' do
          setup do
            put :update, :id => @parameter_name.id, :parameter_name => Factory.attributes_for(:parameter_name)
          end
          should_set_the_flash_to 'Successfully updated parameter name.'
          should_redirect_to('the parameter') { parameter_name_url(assigns(:parameter_name)) }
          should_assign_to(:parameter_name)
        end
        context 'given invalid parameters' do
          setup do
            put :update, :id => @parameter_name.id, :parameter_name => { :name => nil }
          end
          should_respond_with(:success)
          should_render_template(:edit)
          should_assign_to(:parameter_name)
        end
      end

      context 'on DELETE to :destroy' do
        setup do
          delete :destroy, :id => @parameter_name.id
        end
        should_set_the_flash_to 'Successfully destroyed parameter name.'
        should_redirect_to('the parameter index') { parameter_names_url }
      end
    end
    
    context 'with read-only privileges' do
      setup do
        @user.remove_role('admin')
        @user.add_role('executive')
        @parameter_name = Factory(:parameter_name)
      end
      
      context 'on GET to :index' do
        setup do
          get :index
        end
        should_respond_with :success
        should_render_template(:index)
        should_assign_to(:parameter_names)
      end

      context 'on GET to :show' do
        context 'with existing parameter ID' do
          setup do
             get :show, :id => @parameter_name.id
          end
          should_respond_with :success
          should_render_template(:show)
          should_assign_to(:parameter_name)
        end
        context 'with non-existent parameter ID' do
          setup do
            get :show, :id => 0
          end
          should_set_the_flash_to "Couldn't find that parameter name"
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
            post :create, :parameter_name => Factory.attributes_for(:parameter_name)
          end
          should_redirect_to('home page') { root_url }
        end
        context 'given invalid parameters' do
          setup do
            post :create, :parameter_name => { }
          end
          should_redirect_to('home page') { root_url }
        end
      end
      
      context 'on GET to :edit' do
        setup do
          get :edit, :id => @parameter_name.id
        end
        should_redirect_to('home page') { root_url }
      end
      
      context 'on PUT to :update' do
        context 'given valid parameters' do
          setup do
            put :update, :id => @parameter_name.id, :parameter_name => Factory.attributes_for(:parameter_name)
          end
          should_redirect_to('home page') { root_url }
        end
        context 'given invalid parameters' do
          setup do
            put :update, :id => @parameter_name.id, :parameter_name => { :name => nil }
          end
          should_redirect_to('home page') { root_url }
        end
      end

      context 'on DELETE to :destroy' do
        setup do
          delete :destroy, :id => @parameter_name.id
        end
        should_redirect_to('home page') { root_url }
      end
    end
  end

end
