require 'test_helper'

class CpusControllerTest < ActionController::TestCase
  context 'The public' do
    setup do
      @cpu = Factory(:cpu)
    end
    context 'on GET to :index' do
      setup do
        get :index
      end
      should_redirect_to('sign-in page') { sign_in_url }
    end
    
    context 'on GET to :show' do
      context 'with existing cpu ID' do
        setup do
          get :show, :id => @cpu.id
        end
        should_redirect_to('sign-in page') { sign_in_url }
      end
      context 'with non-existent cpu ID' do
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
        get :edit, :id => @cpu.id
      end
      should_redirect_to('sign-in page') { sign_in_url }
    end

    context 'on POST to :create' do
      setup do
        post :create, :cpu => Factory.attributes_for(:cpu)
      end
      should_redirect_to('sign-in page') { sign_in_url }
    end

    context 'on PUT to :update' do
      setup do
        put :update, :id => @cpu.id, :cpu => Factory.attributes_for(:cpu)
      end
      should_redirect_to('sign-in page') { sign_in_url }
    end

    context 'on DELETE to :destroy' do
      setup do
        delete :destroy, :id => @cpu.id
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
        @cpu = Factory(:cpu)
      end

      context 'on GET to :index' do
        setup do
          get :index
        end
        should_respond_with :success
        should_render_template(:index)
        should_assign_to(:cpus)
      end
      
      context 'on GET to :show' do
        context 'with existing cpu ID' do
          setup do
             get :show, :id => @cpu.id
          end
          should_respond_with :success
          should_render_template(:show)
          should_assign_to(:cpu)
        end
        context 'with non-existant cpu ID' do
          setup do
            get :show, :id => 0
          end
          should_set_the_flash_to "Couldn't find that cpu"
          should_redirect_to('home page') { root_url }
        end
      end
      
      context 'on GET to :new' do
        setup do
          get :new
        end
        should_respond_with(:success)
        should_render_template(:new)
        should_assign_to(:cpu)
      end
      
      context 'on POST to :create' do
        context 'given valid parameters' do
          setup do
            post :create, :cpu => Factory.attributes_for(:cpu, :manufacturer => Factory(:manufacturer))
          end
          should_set_the_flash_to 'Successfully created cpu.'
          should_redirect_to('the cpu') { cpu_url(assigns(:cpu)) }
        end
        context 'given invalid parameters' do
          setup do
            post :create, :cpu => { }
          end
          should_respond_with(:success)
          should_render_template(:new)
        end
      end
      
      context 'on GET to :edit' do
        setup do
          get :edit, :id => @cpu.id
        end
        should_respond_with(:success)
        should_render_template(:edit)
        should_assign_to(:cpu)
      end
      
      context 'on PUT to :update' do
        context 'given valid parameters' do
          setup do
            put :update, :id => @cpu.id, :cpu => Factory.attributes_for(:cpu, :manufacturer => Factory(:manufacturer))
          end
          should_set_the_flash_to 'Successfully updated cpu.'
          should_redirect_to('the cpu') { cpu_url(assigns(:cpu)) }
          should_assign_to(:cpu)
        end
        context 'given invalid parameters' do
          setup do
            put :update, :id => @cpu.id, :cpu => { :manufacturer => nil }
          end
          should_respond_with(:success)
          should_render_template(:edit)
          should_assign_to(:cpu)
        end
      end

      context 'on DELETE to :destroy' do
        setup do
          delete :destroy, :id => @cpu.id
        end
        should_set_the_flash_to 'Successfully destroyed cpu.'
        should_redirect_to('the cpu index') { cpus_url }
      end
    end
    
    context 'with read-only privileges' do
      setup do
        @user.remove_role('admin')
        @user.add_role('executive')
        @cpu = Factory(:cpu)
      end
      
      context 'on GET to :index' do
        setup do
          get :index
        end
        should_respond_with :success
        should_render_template(:index)
        should_assign_to(:cpus)
      end

      context 'on GET to :show' do
        context 'with existing cpu ID' do
          setup do
             get :show, :id => @cpu.id
          end
          should_respond_with :success
          should_render_template(:show)
          should_assign_to(:cpu)
        end
        context 'with non-existent cpu ID' do
          setup do
            get :show, :id => 0
          end
          should_set_the_flash_to "Couldn't find that cpu"
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
            post :create, :cpu => Factory.attributes_for(:cpu, :manufacturer => Factory(:manufacturer))
          end
          should_redirect_to('home page') { root_url }
        end
        context 'given invalid parameters' do
          setup do
            post :create, :cpu => { }
          end
          should_redirect_to('home page') { root_url }
        end
      end
      
      context 'on GET to :edit' do
        setup do
          get :edit, :id => @cpu.id
        end
        should_redirect_to('home page') { root_url }
      end
      
      context 'on PUT to :update' do
        context 'given valid parameters' do
          setup do
            put :update, :id => @cpu.id, :cpu => Factory.attributes_for(:cpu, :manufacturer => Factory(:manufacturer))
          end
          should_redirect_to('home page') { root_url }
        end
        context 'given invalid parameters' do
          setup do
            put :update, :id => @cpu.id, :cpu => { :manufacturer => nil }
          end
          should_redirect_to('home page') { root_url }
        end
      end

      context 'on DELETE to :destroy' do
        setup do
          delete :destroy, :id => @cpu.id
        end
        should_redirect_to('home page') { root_url }
      end
    end
  end

end
