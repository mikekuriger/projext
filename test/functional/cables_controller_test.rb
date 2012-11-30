require 'test_helper'

class CablesControllerTest < ActionController::TestCase
  context 'The public' do
    setup do
      @cable = Factory(:cable)
    end
    context 'on GET to :index' do
      setup do
        get :index
      end
      should_redirect_to('sign-in page') { sign_in_url }
    end
    
    context 'on GET to :show' do
      context 'with existing cable ID' do
        setup do
          get :show, :id => @cable.id
        end
        should_redirect_to('sign-in page') { sign_in_url }
      end
      context 'with non-existent cable ID' do
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
        get :edit, :id => @cable.id
      end
      should_redirect_to('sign-in page') { sign_in_url }
    end

    context 'on POST to :create' do
      setup do
        post :create, :cable => Factory.attributes_for(:cable)
      end
      should_redirect_to('sign-in page') { sign_in_url }
    end

    context 'on PUT to :update' do
      setup do
        put :update, :id => @cable.id, :cable => Factory.attributes_for(:cable)
      end
      should_redirect_to('sign-in page') { sign_in_url }
    end

    context 'on DELETE to :destroy' do
      setup do
        delete :destroy, :id => @cable.id
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
        @cable = Factory(:cable)
      end

      context 'on GET to :index' do
        setup do
          get :index
        end
        should_respond_with :success
        should_render_template(:index)
        should_assign_to(:cables)
      end
      
      context 'on GET to :show' do
        context 'with existing cable ID' do
          setup do
             get :show, :id => @cable.id
          end
          should_respond_with :success
          should_render_template(:show)
          should_assign_to(:cable)
        end
        context 'with non-existant cable ID' do
          setup do
            get :show, :id => 0
          end
          should_set_the_flash_to "Couldn't find that cable"
          should_redirect_to('home page') { root_url }
        end
      end
      
      context 'on GET to :new' do
        setup do
          get :new
        end
        should_respond_with(:success)
        should_render_template(:new)
        should_assign_to(:cable)
      end
      
      context 'on POST to :create' do
        context 'given valid parameters' do
          setup do
            post :create, :cable => Factory.attributes_for(:cable, { :interface => Factory(:interface), :interface_target => Factory(:interface) })
          end
          should_set_the_flash_to 'Successfully created cable.'
          should_redirect_to('the cable') { cable_url(assigns(:cable)) }
        end
        context 'given invalid parameters' do
          setup do
            post :create, :cable => { :interface => nil }
          end
          should_respond_with(:success)
          should_render_template(:new)
        end
      end
      
      context 'on GET to :edit' do
        setup do
          get :edit, :id => @cable.id
        end
        should_respond_with(:success)
        should_render_template(:edit)
        should_assign_to(:cable)
      end
      
      context 'on PUT to :update' do
        context 'given valid parameters' do
          setup do
            put :update, :id => @cable.id, :cable => Factory.attributes_for(:cable)
          end
          should_set_the_flash_to 'Successfully updated cable.'
          should_redirect_to('the cable') { cable_url(assigns(:cable)) }
          should_assign_to(:cable)
        end
        context 'given invalid parameters' do
          setup do
            put :update, :id => @cable.id, :cable => { :interface => nil }
          end
          should_respond_with(:success)
          should_render_template(:edit)
          should_assign_to(:cable)
        end
      end

      context 'on DELETE to :destroy' do
        setup do
          delete :destroy, :id => @cable.id
        end
        should_set_the_flash_to 'Successfully destroyed cable.'
        should_redirect_to('the cable index') { cables_url }
      end
    end
    
    context 'with read-only privileges' do
      setup do
        @user.remove_role('admin')
        @user.add_role('executive')
        @cable = Factory(:cable)
      end
      
      context 'on GET to :index' do
        setup do
          get :index
        end
        should_respond_with :success
        should_render_template(:index)
        should_assign_to(:cables)
      end

      context 'on GET to :show' do
        context 'with existing cable ID' do
          setup do
             get :show, :id => @cable.id
          end
          should_respond_with :success
          should_render_template(:show)
          should_assign_to(:cable)
        end
        context 'with non-existent cable ID' do
          setup do
            get :show, :id => 0
          end
          should_set_the_flash_to "Couldn't find that cable"
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
            post :create, :cable => Factory.attributes_for(:cable)
          end
          should_redirect_to('home page') { root_url }
        end
        context 'given invalid parameters' do
          setup do
            post :create, :cable => { }
          end
          should_redirect_to('home page') { root_url }
        end
      end
      
      context 'on GET to :edit' do
        setup do
          get :edit, :id => @cable.id
        end
        should_redirect_to('home page') { root_url }
      end
      
      context 'on PUT to :update' do
        context 'given valid parameters' do
          setup do
            put :update, :id => @cable.id, :cable => Factory.attributes_for(:cable)
          end
          should_redirect_to('home page') { root_url }
        end
        context 'given invalid parameters' do
          setup do
            put :update, :id => @cable.id, :cable => { :from_interface => nil }
          end
          should_redirect_to('home page') { root_url }
        end
      end

      context 'on DELETE to :destroy' do
        setup do
          delete :destroy, :id => @cable.id
        end
        should_redirect_to('home page') { root_url }
      end
    end
  end
end
