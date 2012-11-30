require 'test_helper'

class SoftwareLicensesControllerTest < ActionController::TestCase
  context 'The public' do
    setup do
      @software_license = Factory(:software_license)
    end
    context 'on GET to :index' do
      setup do
        get :index
      end
      should_redirect_to('sign-in page') { sign_in_url }
    end
    
    context 'on GET to :show' do
      context 'with existing software license ID' do
        setup do
          get :show, :id => @software_license.id
        end
        should_redirect_to('sign-in page') { sign_in_url }
      end
      context 'with non-existent software license ID' do
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
        get :edit, :id => @software_license.id
      end
      should_redirect_to('sign-in page') { sign_in_url }
    end

    context 'on POST to :create' do
      setup do
        post :create, :software_license => Factory.attributes_for(:software_license)
      end
      should_redirect_to('sign-in page') { sign_in_url }
    end

    context 'on PUT to :update' do
      setup do
        put :update, :id => @software_license.id, :software_license => Factory.attributes_for(:software_license)
      end
      should_redirect_to('sign-in page') { sign_in_url }
    end

    context 'on DELETE to :destroy' do
      setup do
        delete :destroy, :id => @software_license.id
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
        @software_license = Factory(:software_license)
      end

      context 'on GET to :index' do
        setup do
          get :index
        end
        should_respond_with :success
        should_render_template(:index)
        should_assign_to(:software_licenses)
      end
      
      context 'on GET to :show' do
        context 'with existing software license ID' do
          setup do
             get :show, :id => @software_license.id
          end
          should_respond_with :success
          should_render_template(:show)
          should_assign_to(:software_license)
        end
        context 'with non-existant software license ID' do
          setup do
            get :show, :id => 0
          end
          should_set_the_flash_to "Couldn't find that software license"
          should_redirect_to('home page') { root_url }
        end
      end
      
      context 'on GET to :new' do
        setup do
          get :new
        end
        should_respond_with(:success)
        should_render_template(:new)
        should_assign_to(:software_license)
      end
      
      context 'on POST to :create' do
        context 'given valid parameters' do
          setup do
            post :create, :software_license => Factory.attributes_for(:software_license)
          end
          should_set_the_flash_to 'Successfully created software license.'
          should_redirect_to('the software license') { software_license_url(assigns(:software_license)) }
        end
        context 'given invalid parameters' do
          setup do
            post :create, :software_license => { }
          end
          should_respond_with(:success)
          should_render_template(:new)
        end
      end
      
      context 'on GET to :edit' do
        setup do
          get :edit, :id => @software_license.id
        end
        should_respond_with(:success)
        should_render_template(:edit)
        should_assign_to(:software_license)
      end
      
      context 'on PUT to :update' do
        context 'given valid parameters' do
          setup do
            put :update, :id => @software_license.id, :software_license => Factory.attributes_for(:software_license)
          end
          should_set_the_flash_to 'Successfully updated software license.'
          should_redirect_to('the software license') { software_license_url(assigns(:software_license)) }
          should_assign_to(:software_license)
        end
        context 'given invalid parameters' do
          setup do
            put :update, :id => @software_license.id, :software_license => { :name => nil }
          end
          should_respond_with(:success)
          should_render_template(:edit)
          should_assign_to(:software_license)
        end
      end

      context 'on DELETE to :destroy' do
        setup do
          delete :destroy, :id => @software_license.id
        end
        should_set_the_flash_to 'Successfully destroyed software license.'
        should_redirect_to('the software license index') { software_licenses_url }
      end
    end
    
    context 'with read-only privileges' do
      setup do
        @user.remove_role('admin')
        @user.add_role('executive')
        @software_license = Factory(:software_license)
      end
      
      context 'on GET to :index' do
        setup do
          get :index
        end
        should_respond_with :success
        should_render_template(:index)
        should_assign_to(:software_licenses)
      end

      context 'on GET to :show' do
        context 'with existing software license ID' do
          setup do
             get :show, :id => @software_license.id
          end
          should_respond_with :success
          should_render_template(:show)
          should_assign_to(:software_license)
        end
        context 'with non-existent software license ID' do
          setup do
            get :show, :id => 0
          end
          should_set_the_flash_to "Couldn't find that software license"
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
            post :create, :software_license => Factory.attributes_for(:software_license)
          end
          should_redirect_to('home page') { root_url }
        end
        context 'given invalid parameters' do
          setup do
            post :create, :software_license => { }
          end
          should_redirect_to('home page') { root_url }
        end
      end
      
      context 'on GET to :edit' do
        setup do
          get :edit, :id => @software_license.id
        end
        should_redirect_to('home page') { root_url }
      end
      
      context 'on PUT to :update' do
        context 'given valid parameters' do
          setup do
            put :update, :id => @software_license.id, :software_license => Factory.attributes_for(:software_license)
          end
          should_redirect_to('home page') { root_url }
        end
        context 'given invalid parameters' do
          setup do
            put :update, :id => @software_license.id, :software_license => { :name => nil }
          end
          should_redirect_to('home page') { root_url }
        end
      end

      context 'on DELETE to :destroy' do
        setup do
          delete :destroy, :id => @software_license.id
        end
        should_redirect_to('home page') { root_url }
      end
    end
  end

end
