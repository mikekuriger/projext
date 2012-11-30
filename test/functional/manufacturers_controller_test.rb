require 'test_helper'

class ManufacturersControllerTest < ActionController::TestCase
  context 'The public' do
    setup do
      @manufacturer = Factory(:manufacturer)
    end
    context 'on GET to :index' do
      setup do
        get :index
      end
      should_redirect_to('sign-in page') { sign_in_url }
    end
    
    context 'on GET to :show' do
      context 'with existing manufacturer ID' do
        setup do
          get :show, :id => @manufacturer.id
        end
        should_redirect_to('sign-in page') { sign_in_url }
      end
      context 'with non-existent manufacturer ID' do
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
        get :edit, :id => @manufacturer.id
      end
      should_redirect_to('sign-in page') { sign_in_url }
    end

    context 'on POST to :create' do
      setup do
        post :create, :manufacturer => Factory.attributes_for(:manufacturer)
      end
      should_redirect_to('sign-in page') { sign_in_url }
    end

    context 'on PUT to :update' do
      setup do
        put :update, :id => @manufacturer.id, :manufacturer => Factory.attributes_for(:manufacturer)
      end
      should_redirect_to('sign-in page') { sign_in_url }
    end

    context 'on DELETE to :destroy' do
      setup do
        delete :destroy, :id => @manufacturer.id
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
        @manufacturer = Factory(:manufacturer)
      end

      context 'on GET to :index' do
        setup do
          get :index
        end
        should_respond_with :success
        should_render_template(:index)
        should_assign_to(:manufacturers)
      end
      
      context 'on GET to :show' do
        context 'with existing manufacturer ID' do
          setup do
             get :show, :id => @manufacturer.id
          end
          should_respond_with :success
          should_render_template(:show)
          should_assign_to(:manufacturer)
        end
        context 'with non-existant manufacturer ID' do
          setup do
            get :show, :id => 0
          end
          should_set_the_flash_to "Couldn't find that manufacturer"
          should_redirect_to('home page') { root_url }
        end
      end
      
      context 'on GET to :new' do
        setup do
          get :new
        end
        should_respond_with(:success)
        should_render_template(:new)
        should_assign_to(:manufacturer)
      end
      
      context 'on POST to :create' do
        context 'given valid parameters' do
          setup do
            post :create, :manufacturer => Factory.attributes_for(:manufacturer)
          end
          should_set_the_flash_to 'Successfully created manufacturer.'
          should_redirect_to('the manufacturer') { manufacturer_url(assigns(:manufacturer)) }
        end
        context 'given invalid parameters' do
          setup do
            post :create, :manufacturer => { }
          end
          should_respond_with(:success)
          should_render_template(:new)
        end
      end
      
      context 'on GET to :edit' do
        setup do
          get :edit, :id => @manufacturer.id
        end
        should_respond_with(:success)
        should_render_template(:edit)
        should_assign_to(:manufacturer)
      end
      
      context 'on PUT to :update' do
        context 'given valid parameters' do
          setup do
            put :update, :id => @manufacturer.id, :manufacturer => Factory.attributes_for(:manufacturer)
          end
          should_set_the_flash_to 'Successfully updated manufacturer.'
          should_redirect_to('the manufacturer') { manufacturer_url(assigns(:manufacturer)) }
          should_assign_to(:manufacturer)
        end
        context 'given invalid parameters' do
          setup do
            put :update, :id => @manufacturer.id, :manufacturer => { :name => nil }
          end
          should_respond_with(:success)
          should_render_template(:edit)
          should_assign_to(:manufacturer)
        end
      end

      context 'on DELETE to :destroy' do
        setup do
          delete :destroy, :id => @manufacturer.id
        end
        should_set_the_flash_to 'Successfully destroyed manufacturer.'
        should_redirect_to('the manufacturer index') { manufacturers_url }
      end
    end
    
    context 'with read-only privileges' do
      setup do
        @user.remove_role('admin')
        @user.add_role('executive')
        @manufacturer = Factory(:manufacturer)
      end
      
      context 'on GET to :index' do
        setup do
          get :index
        end
        should_respond_with :success
        should_render_template(:index)
        should_assign_to(:manufacturers)
      end

      context 'on GET to :show' do
        context 'with existing manufacturer ID' do
          setup do
             get :show, :id => @manufacturer.id
          end
          should_respond_with :success
          should_render_template(:show)
          should_assign_to(:manufacturer)
        end
        context 'with non-existent manufacturer ID' do
          setup do
            get :show, :id => 0
          end
          should_set_the_flash_to "Couldn't find that manufacturer"
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
            post :create, :manufacturer => Factory.attributes_for(:manufacturer)
          end
          should_redirect_to('home page') { root_url }
        end
        context 'given invalid parameters' do
          setup do
            post :create, :manufacturer => { }
          end
          should_redirect_to('home page') { root_url }
        end
      end
      
      context 'on GET to :edit' do
        setup do
          get :edit, :id => @manufacturer.id
        end
        should_redirect_to('home page') { root_url }
      end
      
      context 'on PUT to :update' do
        context 'given valid parameters' do
          setup do
            put :update, :id => @manufacturer.id, :manufacturer => Factory.attributes_for(:manufacturer)
          end
          should_redirect_to('home page') { root_url }
        end
        context 'given invalid parameters' do
          setup do
            put :update, :id => @manufacturer.id, :manufacturer => { :name => nil }
          end
          should_redirect_to('home page') { root_url }
        end
      end

      context 'on DELETE to :destroy' do
        setup do
          delete :destroy, :id => @manufacturer.id
        end
        should_redirect_to('home page') { root_url }
      end
    end
  end
end
