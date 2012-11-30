require 'test_helper'

class ClustersControllerTest < ActionController::TestCase
  context 'The public' do
    setup do
      @cluster = Factory(:cluster)
    end
    context 'on GET to :index' do
      setup do
        get :index
      end
      should_redirect_to('sign-in page') { sign_in_url }
    end
    
    context 'on GET to :show' do
      context 'with existing cluster ID' do
        setup do
          get :show, :id => @cluster.id
        end
        should_redirect_to('sign-in page') { sign_in_url }
      end
      context 'with non-existent cluster ID' do
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
        get :edit, :id => @cluster.id
      end
      should_redirect_to('sign-in page') { sign_in_url }
    end

    context 'on POST to :create' do
      setup do
        post :create, :cluster => Factory.attributes_for(:cluster)
      end
      should_redirect_to('sign-in page') { sign_in_url }
    end

    context 'on PUT to :update' do
      setup do
        put :update, :id => @cluster.id, :cluster => Factory.attributes_for(:cluster)
      end
      should_redirect_to('sign-in page') { sign_in_url }
    end

    context 'on DELETE to :destroy' do
      setup do
        delete :destroy, :id => @cluster.id
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
        @cluster = Factory(:cluster)
      end

      context 'on GET to :index' do
        setup do
          get :index
        end
        should_respond_with :success
        should_render_template(:index)
        should_assign_to(:clusters)
      end
      
      context 'on GET to :show' do
        context 'with existing cluster ID' do
          setup do
             get :show, :id => @cluster.id
          end
          should_respond_with :success
          should_render_template(:show)
          should_assign_to(:cluster)
        end
        context 'with non-existant cluster ID' do
          setup do
            get :show, :id => 0
          end
          should_set_the_flash_to "Couldn't find that cluster"
          should_redirect_to('home page') { root_url }
        end
      end
      
      context 'on GET to :new' do
        setup do
          get :new
        end
        should_respond_with(:success)
        should_render_template(:new)
        should_assign_to(:cluster)
      end
      
      context 'on POST to :create' do
        context 'given valid parameters' do
          setup do
            post :create, :cluster => Factory.attributes_for(:cluster)
          end
          should_set_the_flash_to 'Successfully created cluster.'
          should_redirect_to('the cluster') { cluster_url(assigns(:cluster)) }
        end
        context 'given invalid parameters' do
          setup do
            post :create, :cluster => { }
          end
          should_respond_with(:success)
          should_render_template(:new)
        end
      end
      
      context 'on GET to :edit' do
        setup do
          get :edit, :id => @cluster.id
        end
        should_respond_with(:success)
        should_render_template(:edit)
        should_assign_to(:cluster)
      end
      
      context 'on PUT to :update' do
        context 'given valid parameters' do
          setup do
            put :update, :id => @cluster.id, :cluster => Factory.attributes_for(:cluster)
          end
          should_set_the_flash_to 'Successfully updated cluster.'
          should_redirect_to('the cluster') { cluster_url(assigns(:cluster)) }
          should_assign_to(:cluster)
        end
        context 'given invalid parameters' do
          setup do
            put :update, :id => @cluster.id, :cluster => { :name => nil }
          end
          should_respond_with(:success)
          should_render_template(:edit)
          should_assign_to(:cluster)
        end
      end

      context 'on DELETE to :destroy' do
        setup do
          delete :destroy, :id => @cluster.id
        end
        should_set_the_flash_to 'Successfully destroyed cluster.'
        should_redirect_to('the cluster index') { clusters_url }
      end
    end
    
    context 'with read-only privileges' do
      setup do
        @user.remove_role('admin')
        @user.add_role('executive')
        @cluster = Factory(:cluster)
      end
      
      context 'on GET to :index' do
        setup do
          get :index
        end
        should_respond_with :success
        should_render_template(:index)
        should_assign_to(:clusters)
      end

      context 'on GET to :show' do
        context 'with existing cluster ID' do
          setup do
             get :show, :id => @cluster.id
          end
          should_respond_with :success
          should_render_template(:show)
          should_assign_to(:cluster)
        end
        context 'with non-existent cluster ID' do
          setup do
            get :show, :id => 0
          end
          should_set_the_flash_to "Couldn't find that cluster"
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
            post :create, :cluster => Factory.attributes_for(:cluster)
          end
          should_redirect_to('home page') { root_url }
        end
        context 'given invalid parameters' do
          setup do
            post :create, :cluster => { }
          end
          should_redirect_to('home page') { root_url }
        end
      end
      
      context 'on GET to :edit' do
        setup do
          get :edit, :id => @cluster.id
        end
        should_redirect_to('home page') { root_url }
      end
      
      context 'on PUT to :update' do
        context 'given valid parameters' do
          setup do
            put :update, :id => @cluster.id, :cluster => Factory.attributes_for(:cluster)
          end
          should_redirect_to('home page') { root_url }
        end
        context 'given invalid parameters' do
          setup do
            put :update, :id => @cluster.id, :cluster => { :name => nil }
          end
          should_redirect_to('home page') { root_url }
        end
      end

      context 'on DELETE to :destroy' do
        setup do
          delete :destroy, :id => @cluster.id
        end
        should_redirect_to('home page') { root_url }
      end
    end
  end
end
