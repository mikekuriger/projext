require 'test_helper'

class PurchaseOrdersControllerTest < ActionController::TestCase
  context 'The public' do
    setup do
      @purchase_order = Factory(:purchase_order)
    end
    context 'on GET to :index' do
      setup do
        get :index
      end
      should_redirect_to('sign-in page') { sign_in_url }
    end
    
    context 'on GET to :show' do
      context 'with existing purchase_order ID' do
        setup do
          get :show, :id => @purchase_order.id
        end
        should_redirect_to('sign-in page') { sign_in_url }
      end
      context 'with non-existent purchase_order ID' do
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
        get :edit, :id => @purchase_order.id
      end
      should_redirect_to('sign-in page') { sign_in_url }
    end

    context 'on POST to :create' do
      setup do
        post :create, :purchase_order => Factory.attributes_for(:purchase_order)
      end
      should_redirect_to('sign-in page') { sign_in_url }
    end

    context 'on PUT to :update' do
      setup do
        put :update, :id => @purchase_order.id, :purchase_order => Factory.attributes_for(:purchase_order)
      end
      should_redirect_to('sign-in page') { sign_in_url }
    end

    context 'on DELETE to :destroy' do
      setup do
        delete :destroy, :id => @purchase_order.id
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
        @purchase_order = Factory(:purchase_order)
      end

      context 'on GET to :index' do
        setup do
          get :index
        end
        should_respond_with :success
        should_render_template(:index)
        should_assign_to(:purchase_orders)
      end
      
      context 'on GET to :show' do
        context 'with existing purchase_order ID' do
          setup do
             get :show, :id => @purchase_order.id
          end
          should_respond_with :success
          should_render_template(:show)
          should_assign_to(:purchase_order)
        end
        context 'with non-existant purchase_order ID' do
          setup do
            get :show, :id => 0
          end
          should_set_the_flash_to "Couldn't find that purchase order"
          should_redirect_to('home page') { root_url }
        end
      end
      
      context 'on GET to :new' do
        setup do
          get :new
        end
        should_respond_with(:success)
        should_render_template(:new)
        should_assign_to(:purchase_order)
      end
      
      context 'on POST to :create' do
        context 'given valid parameters' do
          setup do
            post :create, :purchase_order => Factory.attributes_for(:purchase_order)
          end
          should_set_the_flash_to 'Successfully created purchase order.'
          should_redirect_to('the purchase_order') { purchase_order_url(assigns(:purchase_order)) }
        end
        context 'given invalid parameters' do
          setup do
            post :create, :purchase_order => { }
          end
          should_respond_with(:success)
          should_render_template(:new)
        end
      end
      
      context 'on GET to :edit' do
        setup do
          get :edit, :id => @purchase_order.id
        end
        should_respond_with(:success)
        should_render_template(:edit)
        should_assign_to(:purchase_order)
      end
      
      context 'on PUT to :update' do
        context 'given valid parameters' do
          setup do
            put :update, :id => @purchase_order.id, :purchase_order => Factory.attributes_for(:purchase_order)
          end
          should_set_the_flash_to 'Successfully updated purchase order.'
          should_redirect_to('the purchase_order') { purchase_order_url(assigns(:purchase_order)) }
          should_assign_to(:purchase_order)
        end
        context 'given invalid parameters' do
          setup do
            put :update, :id => @purchase_order.id, :purchase_order => { :name => nil }
          end
          should_respond_with(:success)
          should_render_template(:edit)
          should_assign_to(:purchase_order)
        end
      end

      context 'on DELETE to :destroy' do
        setup do
          delete :destroy, :id => @purchase_order.id
        end
        should_set_the_flash_to 'Successfully destroyed purchase order.'
        should_redirect_to('the purchase_order index') { purchase_orders_url }
      end
    end
    
    context 'with read-only privileges' do
      setup do
        @user.remove_role('admin')
        @user.add_role('executive')
        @purchase_order = Factory(:purchase_order)
      end
      
      context 'on GET to :index' do
        setup do
          get :index
        end
        should_respond_with :success
        should_render_template(:index)
        should_assign_to(:purchase_orders)
      end

      context 'on GET to :show' do
        context 'with existing purchase_order ID' do
          setup do
             get :show, :id => @purchase_order.id
          end
          should_respond_with :success
          should_render_template(:show)
          should_assign_to(:purchase_order)
        end
        context 'with non-existent purchase_order ID' do
          setup do
            get :show, :id => 0
          end
          should_set_the_flash_to "Couldn't find that purchase order"
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
            post :create, :purchase_order => Factory.attributes_for(:purchase_order)
          end
          should_redirect_to('home page') { root_url }
        end
        context 'given invalid parameters' do
          setup do
            post :create, :purchase_order => { }
          end
          should_redirect_to('home page') { root_url }
        end
      end
      
      context 'on GET to :edit' do
        setup do
          get :edit, :id => @purchase_order.id
        end
        should_redirect_to('home page') { root_url }
      end
      
      context 'on PUT to :update' do
        context 'given valid parameters' do
          setup do
            put :update, :id => @purchase_order.id, :purchase_order => Factory.attributes_for(:purchase_order)
          end
          should_redirect_to('home page') { root_url }
        end
        context 'given invalid parameters' do
          setup do
            put :update, :id => @purchase_order.id, :purchase_order => { :name => nil }
          end
          should_redirect_to('home page') { root_url }
        end
      end

      context 'on DELETE to :destroy' do
        setup do
          delete :destroy, :id => @purchase_order.id
        end
        should_redirect_to('home page') { root_url }
      end
    end
  end
end
