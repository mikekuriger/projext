require 'test_helper'

class HardwareModelsControllerTest < ActionController::TestCase
  context 'The public' do
    setup do
      @hardware_model = Factory(:hardware_model)
    end
    context 'on GET to :index' do
      setup do
        get :index
      end
      should_redirect_to('sign-in page') { sign_in_url }
    end
    
    context 'on GET to :show' do
      context 'with existing hardware_model ID' do
        setup do
          get :show, :id => @hardware_model.id
        end
        should_redirect_to('sign-in page') { sign_in_url }
      end
      context 'with non-existent hardware_model ID' do
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
        get :edit, :id => @hardware_model.id
      end
      should_redirect_to('sign-in page') { sign_in_url }
    end

    context 'on POST to :create' do
      setup do
        post :create, :hardware_model => Factory.attributes_for(:hardware_model)
      end
      should_redirect_to('sign-in page') { sign_in_url }
    end

    context 'on PUT to :update' do
      setup do
        put :update, :id => @hardware_model.id, :hardware_model => Factory.attributes_for(:hardware_model)
      end
      should_redirect_to('sign-in page') { sign_in_url }
    end

    context 'on DELETE to :destroy' do
      setup do
        delete :destroy, :id => @hardware_model.id
      end
      should_redirect_to('sign-in page') { sign_in_url }
    end
    
  end
  
  context 'A signed-in user' do
    setup do
      @user = Factory(:email_confirmed_user)
      @user.activate
      @controller.current_user = @user
    end
    
    context 'with admin privileges' do
      setup do
        @user.add_role('admin')
        @hardware_model = Factory(:hardware_model)
      end

      context 'on GET to :index' do
        setup do
          get :index
        end
        should_respond_with :success
        should_render_template(:index)
        should_assign_to(:hardware_models)
      end
      
      context 'on GET to :show' do
        context 'with existing hardware_model ID' do
          setup do
             get :show, :id => @hardware_model.id
          end
          should_respond_with :success
          should_render_template(:show)
          should_assign_to(:hardware_model)
        end
        context 'with non-existant hardware_model ID' do
          setup do
            get :show, :id => 0
          end
          should_set_the_flash_to "Couldn't find that hardware model"
          should_redirect_to('home page') { root_url }
        end
      end
      
      context 'on GET to :new' do
        setup do
          get :new
        end
        should_respond_with(:success)
        should_render_template(:new)
        should_assign_to(:hardware_model)
      end
      
      context 'on POST to :create' do
        context 'given valid parameters' do
          setup do
            post :create, :hardware_model => Factory.attributes_for(:hardware_model)
          end
          should_set_the_flash_to 'Successfully created hardware model.'
          should_redirect_to('the hardware_model') { hardware_model_url(assigns(:hardware_model)) }
        end
        context 'given invalid parameters' do
          setup do
            post :create, :hardware_model => { }
          end
          should_respond_with(:success)
          should_render_template(:new)
        end
      end
      
      context 'on GET to :edit' do
        setup do
          get :edit, :id => @hardware_model.id
        end
        should_respond_with(:success)
        should_render_template(:edit)
        should_assign_to(:hardware_model)
      end
      
      context 'on PUT to :update' do
        context 'given valid parameters' do
          setup do
            put :update, :id => @hardware_model.id, :hardware_model => Factory.attributes_for(:hardware_model)
          end
          should_set_the_flash_to 'Successfully updated hardware model.'
          should_redirect_to('the hardware_model') { hardware_model_url(assigns(:hardware_model)) }
          should_assign_to(:hardware_model)
        end
        context 'given invalid parameters' do
          setup do
            put :update, :id => @hardware_model.id, :hardware_model => { :name => nil }
          end
          should_respond_with(:success)
          should_render_template(:edit)
          should_assign_to(:hardware_model)
        end
      end

      context 'on DELETE to :destroy' do
        setup do
          delete :destroy, :id => @hardware_model.id
        end
        should_set_the_flash_to 'Successfully destroyed hardware model.'
        should_redirect_to('the hardware_model index') { hardware_models_url }
      end
    end
    
    context 'with read-only privileges' do
      setup do
        @user.remove_role('admin')
        @user.add_role('executive')
        @hardware_model = Factory(:hardware_model)
      end
      
      context 'on GET to :index' do
        setup do
          get :index
        end
        should_respond_with :success
        should_render_template(:index)
        should_assign_to(:hardware_models)
      end

      context 'on GET to :show' do
        context 'with existing hardware_model ID' do
          setup do
             get :show, :id => @hardware_model.id
          end
          should_respond_with :success
          should_render_template(:show)
          should_assign_to(:hardware_model)
        end
        context 'with non-existent hardware_model ID' do
          setup do
            get :show, :id => 0
          end
          should_set_the_flash_to "Couldn't find that hardware model"
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
            post :create, :hardware_model => Factory.attributes_for(:hardware_model)
          end
          should_redirect_to('home page') { root_url }
        end
        context 'given invalid parameters' do
          setup do
            post :create, :hardware_model => { }
          end
          should_redirect_to('home page') { root_url }
        end
      end
      
      context 'on GET to :edit' do
        setup do
          get :edit, :id => @hardware_model.id
        end
        should_redirect_to('home page') { root_url }
      end
      
      context 'on PUT to :update' do
        context 'given valid parameters' do
          setup do
            put :update, :id => @hardware_model.id, :hardware_model => Factory.attributes_for(:hardware_model)
          end
          should_redirect_to('home page') { root_url }
        end
        context 'given invalid parameters' do
          setup do
            put :update, :id => @hardware_model.id, :hardware_model => { :name => nil }
          end
          should_redirect_to('home page') { root_url }
        end
      end

      context 'on DELETE to :destroy' do
        setup do
          delete :destroy, :id => @hardware_model.id
        end
        should_redirect_to('home page') { root_url }
      end
    end
  end
end
