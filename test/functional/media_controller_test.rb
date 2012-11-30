require 'test_helper'

class MediaControllerTest < ActionController::TestCase
  context 'The public' do
    setup do
      @medium = Factory(:medium)
    end
    context 'on GET to :index' do
      setup do
        get :index
      end
      should_redirect_to('sign-in page') { sign_in_url }
    end
    
    context 'on GET to :show' do
      context 'with existing medium ID' do
        setup do
          get :show, :id => @medium.id
        end
        should_redirect_to('sign-in page') { sign_in_url }
      end
      context 'with non-existent medium ID' do
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
        get :edit, :id => @medium.id
      end
      should_redirect_to('sign-in page') { sign_in_url }
    end

    context 'on POST to :create' do
      setup do
        post :create, :medium => Factory.attributes_for(:medium)
      end
      should_redirect_to('sign-in page') { sign_in_url }
    end

    context 'on PUT to :update' do
      setup do
        put :update, :id => @medium.id, :medium => Factory.attributes_for(:medium)
      end
      should_redirect_to('sign-in page') { sign_in_url }
    end

    context 'on DELETE to :destroy' do
      setup do
        delete :destroy, :id => @medium.id
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
        @medium = Factory(:medium)
      end

      context 'on GET to :index' do
        setup do
          get :index
        end
        should_respond_with :success
        should_render_template(:index)
        should_assign_to(:media)
      end
      
      context 'on GET to :show' do
        context 'with existing medium ID' do
          setup do
             get :show, :id => @medium.id
          end
          should_respond_with :success
          should_render_template(:show)
          should_assign_to(:medium)
        end
        context 'with non-existant medium ID' do
          setup do
            get :show, :id => 0
          end
          should_set_the_flash_to "Couldn't find that medium"
          should_redirect_to('home page') { root_url }
        end
      end
      
      context 'on GET to :new' do
        setup do
          get :new
        end
        should_respond_with(:success)
        should_render_template(:new)
        should_assign_to(:medium)
      end
      
      context 'on POST to :create' do
        context 'given valid parameters' do
          setup do
            post :create, :medium => Factory.attributes_for(:medium)
          end
          should_set_the_flash_to 'Successfully created medium.'
          should_redirect_to('the medium') { medium_url(assigns(:medium)) }
        end
        context 'given invalid parameters' do
          setup do
            post :create, :medium => { }
          end
          should_respond_with(:success)
          should_render_template(:new)
        end
      end
      
      context 'on GET to :edit' do
        setup do
          get :edit, :id => @medium.id
        end
        should_respond_with(:success)
        should_render_template(:edit)
        should_assign_to(:medium)
      end
      
      context 'on PUT to :update' do
        context 'given valid parameters' do
          setup do
            put :update, :id => @medium.id, :medium => Factory.attributes_for(:medium)
          end
          should_set_the_flash_to 'Successfully updated medium.'
          should_redirect_to('the medium') { medium_url(assigns(:medium)) }
          should_assign_to(:medium)
        end
        context 'given invalid parameters' do
          setup do
            put :update, :id => @medium.id, :medium => { :name => nil }
          end
          should_respond_with(:success)
          should_render_template(:edit)
          should_assign_to(:medium)
        end
      end

      context 'on DELETE to :destroy' do
        setup do
          delete :destroy, :id => @medium.id
        end
        should_set_the_flash_to 'Successfully destroyed medium.'
        should_redirect_to('the medium index') { media_url }
      end
    end
    
    context 'with read-only privileges' do
      setup do
        @user.remove_role('admin')
        @user.add_role('executive')
        @medium = Factory(:medium)
      end
      
      context 'on GET to :index' do
        setup do
          get :index
        end
        should_respond_with :success
        should_render_template(:index)
        should_assign_to(:media)
      end

      context 'on GET to :show' do
        context 'with existing medium ID' do
          setup do
             get :show, :id => @medium.id
          end
          should_respond_with :success
          should_render_template(:show)
          should_assign_to(:medium)
        end
        context 'with non-existent medium ID' do
          setup do
            get :show, :id => 0
          end
          should_set_the_flash_to "Couldn't find that medium"
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
            post :create, :medium => Factory.attributes_for(:medium)
          end
          should_redirect_to('home page') { root_url }
        end
        context 'given invalid parameters' do
          setup do
            post :create, :medium => { }
          end
          should_redirect_to('home page') { root_url }
        end
      end
      
      context 'on GET to :edit' do
        setup do
          get :edit, :id => @medium.id
        end
        should_redirect_to('home page') { root_url }
      end
      
      context 'on PUT to :update' do
        context 'given valid parameters' do
          setup do
            put :update, :id => @medium.id, :medium => Factory.attributes_for(:medium)
          end
          should_redirect_to('home page') { root_url }
        end
        context 'given invalid parameters' do
          setup do
            put :update, :id => @medium.id, :medium => { :name => nil }
          end
          should_redirect_to('home page') { root_url }
        end
      end

      context 'on DELETE to :destroy' do
        setup do
          delete :destroy, :id => @medium.id
        end
        should_redirect_to('home page') { root_url }
      end
    end
  end
end
