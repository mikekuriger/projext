require 'test_helper'

class EquipmentRacksControllerTest < ActionController::TestCase
  context 'The public' do
    setup do
      @equipment_rack = Factory(:equipment_rack)
    end
    context 'on GET to :index' do
      setup do
        get :index
      end
      should_redirect_to('sign-in page') { sign_in_url }
    end
    
    context 'on GET to :show' do
      context 'with existing equipment_rack ID' do
        setup do
          get :show, :id => @equipment_rack.id
        end
        should_redirect_to('sign-in page') { sign_in_url }
      end
      context 'with non-existent equipment_rack ID' do
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
        get :edit, :id => @equipment_rack.id
      end
      should_redirect_to('sign-in page') { sign_in_url }
    end

    context 'on POST to :create' do
      setup do
        post :create, :equipment_rack => Factory.attributes_for(:equipment_rack)
      end
      should_redirect_to('sign-in page') { sign_in_url }
    end

    context 'on PUT to :update' do
      setup do
        put :update, :id => @equipment_rack.id, :equipment_rack => Factory.attributes_for(:equipment_rack)
      end
      should_redirect_to('sign-in page') { sign_in_url }
    end

    context 'on DELETE to :destroy' do
      setup do
        delete :destroy, :id => @equipment_rack.id
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
        @equipment_rack = Factory(:equipment_rack)
      end

      context 'on GET to :index' do
        setup do
          get :index
        end
        should_respond_with :success
        should_render_template(:index)
        should_assign_to(:equipment_racks)
      end
      
      context 'on GET to :show' do
        context 'with existing equipment_rack ID' do
          setup do
             get :show, :id => @equipment_rack.id
          end
          should_respond_with :success
          should_render_template(:show)
          should_assign_to(:equipment_rack)
        end
        context 'with non-existant equipment_rack ID' do
          setup do
            get :show, :id => 0
          end
          should_set_the_flash_to "Couldn't find that equipment rack"
          should_redirect_to('home page') { root_url }
        end
      end
      
      context 'on GET to :new' do
        setup do
          get :new
        end
        should_respond_with(:success)
        should_render_template(:new)
        should_assign_to(:equipment_rack)
      end
      
      context 'on POST to :create' do
        context 'given valid parameters' do
          setup do
            post :create, :equipment_rack => Factory.attributes_for(:equipment_rack)
          end
          should_set_the_flash_to 'Successfully created equipment rack.'
          should_redirect_to('the equipment_rack') { equipment_rack_url(assigns(:equipment_rack)) }
        end
        context 'given invalid parameters' do
          setup do
            post :create, :equipment_rack => { }
          end
          should_respond_with(:success)
          should_render_template(:new)
        end
      end
      
      context 'on GET to :edit' do
        setup do
          get :edit, :id => @equipment_rack.id
        end
        should_respond_with(:success)
        should_render_template(:edit)
        should_assign_to(:equipment_rack)
      end
      
      context 'on PUT to :update' do
        context 'given valid parameters' do
          setup do
            put :update, :id => @equipment_rack.id, :equipment_rack => Factory.attributes_for(:equipment_rack)
          end
          should_set_the_flash_to 'Successfully updated equipment rack.'
          should_redirect_to('the equipment_rack') { equipment_rack_url(assigns(:equipment_rack)) }
          should_assign_to(:equipment_rack)
        end
        context 'given invalid parameters' do
          setup do
            put :update, :id => @equipment_rack.id, :equipment_rack => { :name => nil }
          end
          should_respond_with(:success)
          should_render_template(:edit)
          should_assign_to(:equipment_rack)
        end
      end

      context 'on DELETE to :destroy' do
        setup do
          delete :destroy, :id => @equipment_rack.id
        end
        should_set_the_flash_to 'Successfully destroyed equipment rack.'
        should_redirect_to('the equipment_rack index') { equipment_racks_url }
      end
    end
    
    context 'with read-only privileges' do
      setup do
        @user.remove_role('admin')
        @user.add_role('executive')
        @equipment_rack = Factory(:equipment_rack)
      end
      
      context 'on GET to :index' do
        setup do
          get :index
        end
        should_respond_with :success
        should_render_template(:index)
        should_assign_to(:equipment_racks)
      end

      context 'on GET to :show' do
        context 'with existing equipment_rack ID' do
          setup do
             get :show, :id => @equipment_rack.id
          end
          should_respond_with :success
          should_render_template(:show)
          should_assign_to(:equipment_rack)
        end
        context 'with non-existent equipment_rack ID' do
          setup do
            get :show, :id => 0
          end
          should_set_the_flash_to "Couldn't find that equipment rack"
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
            post :create, :equipment_rack => Factory.attributes_for(:equipment_rack)
          end
          should_redirect_to('home page') { root_url }
        end
        context 'given invalid parameters' do
          setup do
            post :create, :equipment_rack => { }
          end
          should_redirect_to('home page') { root_url }
        end
      end
      
      context 'on GET to :edit' do
        setup do
          get :edit, :id => @equipment_rack.id
        end
        should_redirect_to('home page') { root_url }
      end
      
      context 'on PUT to :update' do
        context 'given valid parameters' do
          setup do
            put :update, :id => @equipment_rack.id, :equipment_rack => Factory.attributes_for(:equipment_rack)
          end
          should_redirect_to('home page') { root_url }
        end
        context 'given invalid parameters' do
          setup do
            put :update, :id => @equipment_rack.id, :equipment_rack => { :name => nil }
          end
          should_redirect_to('home page') { root_url }
        end
      end

      context 'on DELETE to :destroy' do
        setup do
          delete :destroy, :id => @equipment_rack.id
        end
        should_redirect_to('home page') { root_url }
      end
    end
  end
end
