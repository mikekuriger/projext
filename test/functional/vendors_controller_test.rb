require 'test_helper'

class VendorsControllerTest < ActionController::TestCase
  context 'The public' do
    setup do
      @vendor = Factory(:vendor)
    end
    context 'on GET to :index' do
      setup do
        get :index
      end
      should_redirect_to('sign-in page') { sign_in_url }
    end
    
    context 'on GET to :show' do
      context 'with existing vendor ID' do
        setup do
          get :show, :id => @vendor.id
        end
        should_redirect_to('sign-in page') { sign_in_url }
      end
      context 'with non-existent vendor ID' do
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
        get :edit, :id => @vendor.id
      end
      should_redirect_to('sign-in page') { sign_in_url }
    end

    context 'on POST to :create' do
      setup do
        post :create, :vendor => Factory.attributes_for(:vendor)
      end
      should_redirect_to('sign-in page') { sign_in_url }
    end

    context 'on PUT to :update' do
      setup do
        put :update, :id => @vendor.id, :vendor => Factory.attributes_for(:vendor)
      end
      should_redirect_to('sign-in page') { sign_in_url }
    end

    context 'on DELETE to :destroy' do
      setup do
        delete :destroy, :id => @vendor.id
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
        @vendor = Factory(:vendor)
      end

      context 'on GET to :index' do
        setup do
          get :index
        end
        should_respond_with :success
        should_render_template(:index)
        should_assign_to(:vendors)
      end
      
      context 'on GET to :show' do
        context 'with existing vendor ID' do
          setup do
             get :show, :id => @vendor.id
          end
          should_respond_with :success
          should_render_template(:show)
          should_assign_to(:vendor)
        end
        context 'with non-existant vendor ID' do
          setup do
            get :show, :id => 0
          end
          should_set_the_flash_to "Couldn't find that vendor"
          should_redirect_to('home page') { root_url }
        end
      end
      
      context 'on GET to :new' do
        setup do
          get :new
        end
        should_respond_with(:success)
        should_render_template(:new)
        should_assign_to(:vendor)
      end
      
      context 'on POST to :create' do
        context 'given valid parameters' do
          setup do
            post :create, :vendor => Factory.attributes_for(:vendor)
          end
          should_set_the_flash_to 'Successfully created vendor.'
          should_redirect_to('the vendor') { vendor_url(assigns(:vendor)) }
        end
        context 'given invalid parameters' do
          setup do
            post :create, :vendor => { }
          end
          should_respond_with(:success)
          should_render_template(:new)
        end
      end
      
      context 'on GET to :edit' do
        setup do
          get :edit, :id => @vendor.id
        end
        should_respond_with(:success)
        should_render_template(:edit)
        should_assign_to(:vendor)
      end
      
      context 'on PUT to :update' do
        context 'given valid parameters' do
          setup do
            put :update, :id => @vendor.id, :vendor => Factory.attributes_for(:vendor)
          end
          should_set_the_flash_to 'Successfully updated vendor.'
          should_redirect_to('the vendor') { vendor_url(assigns(:vendor)) }
          should_assign_to(:vendor)
        end
        context 'given invalid parameters' do
          setup do
            put :update, :id => @vendor.id, :vendor => { :name => nil }
          end
          should_respond_with(:success)
          should_render_template(:edit)
          should_assign_to(:vendor)
        end
      end

      context 'on DELETE to :destroy' do
        setup do
          delete :destroy, :id => @vendor.id
        end
        should_set_the_flash_to 'Successfully destroyed vendor.'
        should_redirect_to('the vendor index') { vendors_url }
      end
    end
    
    context 'with read-only privileges' do
      setup do
        @user.remove_role('admin')
        @user.add_role('executive')
        @vendor = Factory(:vendor)
      end
      
      context 'on GET to :index' do
        setup do
          get :index
        end
        should_respond_with :success
        should_render_template(:index)
        should_assign_to(:vendors)
      end

      context 'on GET to :show' do
        context 'with existing vendor ID' do
          setup do
             get :show, :id => @vendor.id
          end
          should_respond_with :success
          should_render_template(:show)
          should_assign_to(:vendor)
        end
        context 'with non-existent vendor ID' do
          setup do
            get :show, :id => 0
          end
          should_set_the_flash_to "Couldn't find that vendor"
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
            post :create, :vendor => Factory.attributes_for(:vendor)
          end
          should_redirect_to('home page') { root_url }
        end
        context 'given invalid parameters' do
          setup do
            post :create, :vendor => { }
          end
          should_redirect_to('home page') { root_url }
        end
      end
      
      context 'on GET to :edit' do
        setup do
          get :edit, :id => @vendor.id
        end
        should_redirect_to('home page') { root_url }
      end
      
      context 'on PUT to :update' do
        context 'given valid parameters' do
          setup do
            put :update, :id => @vendor.id, :vendor => Factory.attributes_for(:vendor)
          end
          should_redirect_to('home page') { root_url }
        end
        context 'given invalid parameters' do
          setup do
            put :update, :id => @vendor.id, :vendor => { :name => nil }
          end
          should_redirect_to('home page') { root_url }
        end
      end

      context 'on DELETE to :destroy' do
        setup do
          delete :destroy, :id => @vendor.id
        end
        should_redirect_to('home page') { root_url }
      end
    end
  end
end
