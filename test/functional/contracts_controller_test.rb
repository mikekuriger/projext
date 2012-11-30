require 'test_helper'

class ContractsControllerTest < ActionController::TestCase
  context 'The public' do
    setup do
      @contract = Factory(:contract)
    end
    context 'on GET to :index' do
      setup do
        get :index
      end
      should_redirect_to('sign-in page') { sign_in_url }
    end
    
    context 'on GET to :show' do
      context 'with existing contract ID' do
        setup do
          get :show, :id => @contract.id
        end
        should_redirect_to('sign-in page') { sign_in_url }
      end
      context 'with non-existent contract ID' do
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
        get :edit, :id => @contract.id
      end
      should_redirect_to('sign-in page') { sign_in_url }
    end

    context 'on POST to :create' do
      setup do
        post :create, :contract => Factory.attributes_for(:contract)
      end
      should_redirect_to('sign-in page') { sign_in_url }
    end

    context 'on PUT to :update' do
      setup do
        put :update, :id => @contract.id, :contract => Factory.attributes_for(:contract)
      end
      should_redirect_to('sign-in page') { sign_in_url }
    end

    context 'on DELETE to :destroy' do
      setup do
        delete :destroy, :id => @contract.id
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
        @contract = Factory(:contract)
      end

      context 'on GET to :index' do
        setup do
          get :index
        end
        should_respond_with :success
        should_render_template(:index)
        should_assign_to(:contracts)
      end
      
      context 'on GET to :show' do
        context 'with existing contract ID' do
          setup do
             get :show, :id => @contract.id
          end
          should_respond_with :success
          should_render_template(:show)
          should_assign_to(:contract)
        end
        context 'with non-existant contract ID' do
          setup do
            get :show, :id => 0
          end
          should_set_the_flash_to "Couldn't find that contract"
          should_redirect_to('home page') { root_url }
        end
      end
      
      context 'on GET to :download' do
        setup do
          get :download, :id => @contract.id, :format => 'pdf'
        end
        should_respond_with :success
      end
      
      context 'on GET to :new' do
        setup do
          get :new
        end
        should_respond_with(:success)
        should_render_template(:new)
        should_assign_to(:contract)
      end
      
      context 'on POST to :create' do
        context 'given valid parameters' do
          setup do
            post :create, :contract => Factory.attributes_for(:contract)
          end
          should_set_the_flash_to 'Successfully created contract.'
          should_redirect_to('the contract') { contract_url(assigns(:contract)) }
        end
        context 'given invalid parameters' do
          setup do
            post :create, :contract => { }
          end
          should_respond_with(:success)
          should_render_template(:new)
        end
      end
      
      context 'on GET to :edit' do
        setup do
          get :edit, :id => @contract.id
        end
        should_respond_with(:success)
        should_render_template(:edit)
        should_assign_to(:contract)
      end
      
      context 'on PUT to :update' do
        context 'given valid parameters' do
          setup do
            put :update, :id => @contract.id, :contract => Factory.attributes_for(:contract)
          end
          should_set_the_flash_to 'Successfully updated contract.'
          should_redirect_to('the contract') { contract_url(assigns(:contract)) }
          should_assign_to(:contract)
        end
        context 'given invalid parameters' do
          setup do
            put :update, :id => @contract.id, :contract => { :name => nil }
          end
          should_respond_with(:success)
          should_render_template(:edit)
          should_assign_to(:contract)
        end
      end

      context 'on DELETE to :destroy' do
        setup do
          delete :destroy, :id => @contract.id
        end
        should_set_the_flash_to 'Successfully destroyed contract.'
        should_redirect_to('the contract index') { contracts_url }
      end
    end
    
    context 'with read-only privileges' do
      setup do
        @user.remove_role('admin')
        @user.add_role('executive')
        @contract = Factory(:contract)
      end
      
      context 'on GET to :index' do
        setup do
          get :index
        end
        should_respond_with :success
        should_render_template(:index)
        should_assign_to(:contracts)
      end

      context 'on GET to :show' do
        context 'with existing contract ID' do
          setup do
             get :show, :id => @contract.id
          end
          should_respond_with :success
          should_render_template(:show)
          should_assign_to(:contract)
        end
        context 'with non-existent contract ID' do
          setup do
            get :show, :id => 0
          end
          should_set_the_flash_to "Couldn't find that contract"
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
            post :create, :contract => Factory.attributes_for(:contract)
          end
          should_redirect_to('home page') { root_url }
        end
        context 'given invalid parameters' do
          setup do
            post :create, :contract => { }
          end
          should_redirect_to('home page') { root_url }
        end
      end
      
      context 'on GET to :edit' do
        setup do
          get :edit, :id => @contract.id
        end
        should_redirect_to('home page') { root_url }
      end
      
      context 'on PUT to :update' do
        context 'given valid parameters' do
          setup do
            put :update, :id => @contract.id, :contract => Factory.attributes_for(:contract)
          end
          should_redirect_to('home page') { root_url }
        end
        context 'given invalid parameters' do
          setup do
            put :update, :id => @contract.id, :contract => { :name => nil }
          end
          should_redirect_to('home page') { root_url }
        end
      end

      context 'on DELETE to :destroy' do
        setup do
          delete :destroy, :id => @contract.id
        end
        should_redirect_to('home page') { root_url }
      end
    end
  end
end
