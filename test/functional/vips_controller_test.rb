require 'test_helper'

class VipsControllerTest < ActionController::TestCase
  context 'The public' do
    setup do
      @vip = Factory(:vip)
    end
    context 'on GET to :index' do
      setup do
        get :index
      end
      should_redirect_to('sign-in page') { sign_in_url }
    end
    
    context 'on GET to :show' do
      context 'with existing vip ID' do
        setup do
          get :show, :id => @vip.id
        end
        should_redirect_to('sign-in page') { sign_in_url }
      end
      context 'with non-existent vip ID' do
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
        get :edit, :id => @vip.id
      end
      should_redirect_to('sign-in page') { sign_in_url }
    end

    context 'on POST to :create' do
      setup do
        post :create, :vip => Factory.attributes_for(:vip)
      end
      should_redirect_to('sign-in page') { sign_in_url }
    end

    context 'on PUT to :update' do
      setup do
        put :update, :id => @vip.id, :vip => Factory.attributes_for(:vip)
      end
      should_redirect_to('sign-in page') { sign_in_url }
    end

    context 'on DELETE to :destroy' do
      setup do
        delete :destroy, :id => @vip.id
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
        @vip = Factory(:vip)
      end

      context 'on GET to :index' do
        setup do
          get :index
        end
        should_respond_with :success
        should_render_template(:index)
        should_assign_to(:vips)
      end
      
      context 'on GET to :show' do
        context 'with existing vip ID' do
          setup do
             get :show, :id => @vip.id
          end
          should_respond_with :success
          should_render_template(:show)
          should_assign_to(:vip)
        end
        context 'with non-existant vip ID' do
          setup do
            get :show, :id => 0
          end
          should_set_the_flash_to "Couldn't find that vip"
          should_redirect_to('home page') { root_url }
        end
      end
      
      context 'on GET to :new' do
        setup do
          get :new
        end
        should_respond_with(:success)
        should_render_template(:new)
        should_assign_to(:vip)
      end
      
      context 'on POST to :create' do
        context 'given valid parameters' do
          setup do
            post :create, :vip => Factory.attributes_for(:vip, { :ip => Factory(:ip) })
          end
          should_set_the_flash_to 'Successfully created vip.'
          should_redirect_to('the vip') { vip_url(assigns(:vip)) }
        end
        context 'given invalid parameters' do
          setup do
            post :create, :vip => { }
          end
          should_respond_with(:success)
          should_render_template(:new)
        end
      end
      
      context 'on GET to :edit' do
        setup do
          get :edit, :id => @vip.id
        end
        should_respond_with(:success)
        should_render_template(:edit)
        should_assign_to(:vip)
      end
      
      context 'on PUT to :update' do
        context 'given valid parameters' do
          setup do
            put :update, :id => @vip.id, :vip => Factory.attributes_for(:vip)
          end
          should_set_the_flash_to 'Successfully updated vip.'
          should_redirect_to('the vip') { vip_url(assigns(:vip)) }
          should_assign_to(:vip)
        end
        context 'given invalid parameters' do
          setup do
            put :update, :id => @vip.id, :vip => { :name => nil }
          end
          should_respond_with(:success)
          should_render_template(:edit)
          should_assign_to(:vip)
        end
      end

      context 'on DELETE to :destroy' do
        setup do
          delete :destroy, :id => @vip.id
        end
        should_set_the_flash_to 'Successfully destroyed vip.'
        should_redirect_to('the vip index') { vips_url }
      end
    end
    
    context 'with read-only privileges' do
      setup do
        @user.remove_role('admin')
        @user.add_role('executive')
        @vip = Factory(:vip)
      end
      
      context 'on GET to :index' do
        setup do
          get :index
        end
        should_respond_with :success
        should_render_template(:index)
        should_assign_to(:vips)
      end

      context 'on GET to :show' do
        context 'with existing vip ID' do
          setup do
             get :show, :id => @vip.id
          end
          should_respond_with :success
          should_render_template(:show)
          should_assign_to(:vip)
        end
        context 'with non-existent vip ID' do
          setup do
            get :show, :id => 0
          end
          should_set_the_flash_to "Couldn't find that vip"
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
            post :create, :vip => Factory.attributes_for(:vip, { :ip => Factory(:ip) })
          end
          should_redirect_to('home page') { root_url }
        end
        context 'given invalid parameters' do
          setup do
            post :create, :vip => { }
          end
          should_redirect_to('home page') { root_url }
        end
      end
      
      context 'on GET to :edit' do
        setup do
          get :edit, :id => @vip.id
        end
        should_redirect_to('home page') { root_url }
      end
      
      context 'on PUT to :update' do
        context 'given valid parameters' do
          setup do
            put :update, :id => @vip.id, :vip => Factory.attributes_for(:vip)
          end
          should_redirect_to('home page') { root_url }
        end
        context 'given invalid parameters' do
          setup do
            put :update, :id => @vip.id, :vip => { :name => nil }
          end
          should_redirect_to('home page') { root_url }
        end
      end

      context 'on DELETE to :destroy' do
        setup do
          delete :destroy, :id => @vip.id
        end
        should_redirect_to('home page') { root_url }
      end
    end
  end
end
