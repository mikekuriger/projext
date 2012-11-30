require 'test_helper'

class GroupsControllerTest < ActionController::TestCase
  context 'The public' do
    setup do
      @group = Factory(:group)
    end
    context 'on GET to :index' do
      setup do
        get :index
      end
      should_redirect_to('sign-in page') { sign_in_url }
    end
    
    context 'on GET to :show' do
      context 'with existing group ID' do
        setup do
          get :show, :id => @group.id
        end
        should_redirect_to('sign-in page') { sign_in_url }
      end
      context 'with non-existent group ID' do
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
        get :edit, :id => @group.id
      end
      should_redirect_to('sign-in page') { sign_in_url }
    end

    context 'on POST to :create' do
      setup do
        post :create, :group => Factory.attributes_for(:group)
      end
      should_redirect_to('sign-in page') { sign_in_url }
    end

    context 'on PUT to :update' do
      setup do
        put :update, :id => @group.id, :group => Factory.attributes_for(:group)
      end
      should_redirect_to('sign-in page') { sign_in_url }
    end

    context 'on DELETE to :destroy' do
      setup do
        delete :destroy, :id => @group.id
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
        @group = Factory(:group)
      end

      context 'on GET to :index' do
        setup do
          get :index
        end
        should_respond_with :success
        should_render_template(:index)
        should_assign_to(:groups)
      end
      
      context 'on GET to :show' do
        context 'with existing group ID' do
          setup do
             get :show, :id => @group.id
          end
          should_respond_with :success
          should_render_template(:show)
          should_assign_to(:group)
        end
        context 'with non-existant group ID' do
          setup do
            get :show, :id => 0
          end
          should_set_the_flash_to "Couldn't find that group"
          should_redirect_to('home page') { root_url }
        end
      end
      
      context 'on GET to :new' do
        setup do
          get :new
        end
        should_respond_with(:success)
        should_render_template(:new)
        should_assign_to(:group)
      end
      
      context 'on POST to :create' do
        context 'given valid parameters' do
          setup do
            post :create, :group => Factory.attributes_for(:group)
          end
          should_set_the_flash_to 'Successfully created group.'
          should_redirect_to('the group') { group_url(assigns(:group)) }
        end
        context 'given invalid parameters' do
          setup do
            post :create, :group => { }
          end
          should_respond_with(:success)
          should_render_template(:new)
        end
      end
      
      context 'on GET to :edit' do
        setup do
          get :edit, :id => @group.id
        end
        should_respond_with(:success)
        should_render_template(:edit)
        should_assign_to(:group)
      end
      
      context 'on PUT to :update' do
        context 'given valid parameters' do
          setup do
            put :update, :id => @group.id, :group => Factory.attributes_for(:group)
          end
          should_set_the_flash_to 'Successfully updated group.'
          should_redirect_to('the group') { group_url(assigns(:group)) }
          should_assign_to(:group)
        end
        context 'given invalid parameters' do
          setup do
            put :update, :id => @group.id, :group => { :name => nil }
          end
          should_respond_with(:success)
          should_render_template(:edit)
          should_assign_to(:group)
        end
      end

      context 'on DELETE to :destroy' do
        setup do
          delete :destroy, :id => @group.id
        end
        should_set_the_flash_to 'Successfully destroyed group.'
        should_redirect_to('the group index') { groups_url }
      end
    end
    
    context 'with read-only privileges' do
      setup do
        @user.remove_role('admin')
        @user.add_role('executive')
        @group = Factory(:group)
      end
      
      context 'on GET to :index' do
        setup do
          get :index
        end
        should_respond_with :success
        should_render_template(:index)
        should_assign_to(:groups)
      end

      context 'on GET to :show' do
        context 'with existing group ID' do
          setup do
             get :show, :id => @group.id
          end
          should_respond_with :success
          should_render_template(:show)
          should_assign_to(:group)
        end
        context 'with non-existent group ID' do
          setup do
            get :show, :id => 0
          end
          should_set_the_flash_to "Couldn't find that group"
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
            post :create, :group => Factory.attributes_for(:group)
          end
          should_redirect_to('home page') { root_url }
        end
        context 'given invalid parameters' do
          setup do
            post :create, :group => { }
          end
          should_redirect_to('home page') { root_url }
        end
      end
      
      context 'on GET to :edit' do
        setup do
          get :edit, :id => @group.id
        end
        should_redirect_to('home page') { root_url }
      end
      
      context 'on PUT to :update' do
        context 'given valid parameters' do
          setup do
            put :update, :id => @group.id, :group => Factory.attributes_for(:group)
          end
          should_redirect_to('home page') { root_url }
        end
        context 'given invalid parameters' do
          setup do
            put :update, :id => @group.id, :group => { :name => nil }
          end
          should_redirect_to('home page') { root_url }
        end
      end

      context 'on DELETE to :destroy' do
        setup do
          delete :destroy, :id => @group.id
        end
        should_redirect_to('home page') { root_url }
      end
    end
  end
end
