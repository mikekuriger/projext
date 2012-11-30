require 'test_helper'

class IpsControllerTest < ActionController::TestCase
  context 'The public' do
    setup do
      @ip = Factory(:ip)
    end
    context 'on GET to :index' do
      setup do
        get :index
      end
      should_redirect_to('sign-in page') { sign_in_url }
    end
    
    context 'on GET to :show' do
      context 'with existing ip ID' do
        setup do
          get :show, :id => @ip.id
        end
        should_redirect_to('sign-in page') { sign_in_url }
      end
      context 'with non-existent ip ID' do
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
        get :edit, :id => @ip.id
      end
      should_redirect_to('sign-in page') { sign_in_url }
    end

    context 'on POST to :create' do
      setup do
        post :create, :ip => Factory.attributes_for(:ip)
      end
      should_redirect_to('sign-in page') { sign_in_url }
    end

    context 'on PUT to :update' do
      setup do
        put :update, :id => @ip.id, :ip => Factory.attributes_for(:ip)
      end
      should_redirect_to('sign-in page') { sign_in_url }
    end

    context 'on DELETE to :destroy' do
      setup do
        delete :destroy, :id => @ip.id
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
        @ip = Factory(:ip)
      end

      context 'on GET to :index' do
        setup do
          get :index
        end
        should_respond_with :success
        should_render_template(:index)
        should_assign_to(:ips)
      end
      
      context 'on GET to :show' do
        context 'with existing ip ID' do
          setup do
             get :show, :id => @ip.id
          end
          should_respond_with :success
          should_render_template(:show)
          should_assign_to(:ip)
        end
        context 'with non-existant ip ID' do
          setup do
            get :show, :id => 0
          end
          should_set_the_flash_to "Couldn't find that IP"
          should_redirect_to('home page') { root_url }
        end
      end
      
      context 'on GET to :new' do
        setup do
          get :new
        end
        should_respond_with(:success)
        should_render_template(:new)
        should_assign_to(:ip)
      end
      
      context 'on POST to :create' do
        context 'given valid parameters' do
          setup do
            post :create, :ip => Factory.attributes_for(:ip)
          end
          should_set_the_flash_to 'Successfully created ip.'
          should_redirect_to('the ip') { ip_url(assigns(:ip)) }
        end
        context 'given invalid parameters' do
          setup do
            post :create, :ip => { }
          end
          should_respond_with(:success)
          should_render_template(:new)
        end
      end
      
      context 'on GET to :edit' do
        setup do
          get :edit, :id => @ip.id
        end
        should_respond_with(:success)
        should_render_template(:edit)
        should_assign_to(:ip)
      end
      
      context 'on PUT to :update' do
        context 'given valid parameters' do
          setup do
            put :update, :id => @ip.id, :ip => Factory.attributes_for(:ip)
          end
          should_set_the_flash_to 'Successfully updated ip.'
          should_redirect_to('the ip') { ip_url(assigns(:ip)) }
          should_assign_to(:ip)
        end
        context 'given invalid parameters' do
          setup do
            put :update, :id => @ip.id, :ip => { :ip => nil }
          end
          should_respond_with(:success)
          should_render_template(:edit)
          should_assign_to(:ip)
        end
      end

      context 'on DELETE to :destroy' do
        setup do
          delete :destroy, :id => @ip.id
        end
        should_set_the_flash_to 'Successfully destroyed ip.'
        should_redirect_to('the ip index') { ips_url }
      end
    end
    
    context 'with read-only privileges' do
      setup do
        @user.remove_role('admin')
        @user.add_role('executive')
        @ip = Factory(:ip)
      end
      
      context 'on GET to :index' do
        setup do
          get :index
        end
        should_respond_with :success
        should_render_template(:index)
        should_assign_to(:ips)
      end

      context 'on GET to :show' do
        context 'with existing ip ID' do
          setup do
             get :show, :id => @ip.id
          end
          should_respond_with :success
          should_render_template(:show)
          should_assign_to(:ip)
        end
        context 'with non-existent ip ID' do
          setup do
            get :show, :id => 0
          end
          should_set_the_flash_to "Couldn't find that IP"
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
            post :create, :ip => Factory.attributes_for(:ip)
          end
          should_redirect_to('home page') { root_url }
        end
        context 'given invalid parameters' do
          setup do
            post :create, :ip => { }
          end
          should_redirect_to('home page') { root_url }
        end
      end
      
      context 'on GET to :edit' do
        setup do
          get :edit, :id => @ip.id
        end
        should_redirect_to('home page') { root_url }
      end
      
      context 'on PUT to :update' do
        context 'given valid parameters' do
          setup do
            put :update, :id => @ip.id, :ip => Factory.attributes_for(:ip)
          end
          should_redirect_to('home page') { root_url }
        end
        context 'given invalid parameters' do
          setup do
            put :update, :id => @ip.id, :ip => { :ip => nil }
          end
          should_redirect_to('home page') { root_url }
        end
      end

      context 'on DELETE to :destroy' do
        setup do
          delete :destroy, :id => @ip.id
        end
        should_redirect_to('home page') { root_url }
      end
    end
  end
end
