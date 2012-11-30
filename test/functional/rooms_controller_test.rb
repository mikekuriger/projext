require 'test_helper'

class RoomsControllerTest < ActionController::TestCase
  context 'The public' do
    setup do
      @room = Factory(:room)
    end
    context 'on GET to :index' do
      setup do
        get :index
      end
      should_redirect_to('sign-in page') { sign_in_url }
    end
    
    context 'on GET to :show' do
      context 'with existing room ID' do
        setup do
          get :show, :id => @room.id
        end
        should_redirect_to('sign-in page') { sign_in_url }
      end
      context 'with non-existent room ID' do
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
        get :edit, :id => @room.id
      end
      should_redirect_to('sign-in page') { sign_in_url }
    end

    context 'on POST to :create' do
      setup do
        post :create, :room => Factory.attributes_for(:room)
      end
      should_redirect_to('sign-in page') { sign_in_url }
    end

    context 'on PUT to :update' do
      setup do
        put :update, :id => @room.id, :room => Factory.attributes_for(:room)
      end
      should_redirect_to('sign-in page') { sign_in_url }
    end

    context 'on DELETE to :destroy' do
      setup do
        delete :destroy, :id => @room.id
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
        @room = Factory(:room)
      end

      context 'on GET to :index' do
        setup do
          get :index
        end
        should_respond_with :success
        should_render_template(:index)
        should_assign_to(:rooms)
      end
      
      context 'on GET to :show' do
        context 'with existing room ID' do
          setup do
             get :show, :id => @room.id
          end
          should_respond_with :success
          should_render_template(:show)
          should_assign_to(:room)
        end
        context 'with non-existant room ID' do
          setup do
            get :show, :id => 0
          end
          should_set_the_flash_to "Couldn't find that room"
          should_redirect_to('home page') { root_url }
        end
      end
      
      context 'on GET to :new' do
        setup do
          get :new
        end
        should_respond_with(:success)
        should_render_template(:new)
        should_assign_to(:room)
      end
      
      context 'on POST to :create' do
        context 'given valid parameters' do
          setup do
            post :create, :room => Factory.attributes_for(:room)
          end
          should_set_the_flash_to 'Successfully created room.'
          should_redirect_to('the room') { room_url(assigns(:room)) }
        end
        context 'given invalid parameters' do
          setup do
            post :create, :room => { }
          end
          should_respond_with(:success)
          should_render_template(:new)
        end
      end
      
      context 'on GET to :edit' do
        setup do
          get :edit, :id => @room.id
        end
        should_respond_with(:success)
        should_render_template(:edit)
        should_assign_to(:room)
      end
      
      context 'on PUT to :update' do
        context 'given valid parameters' do
          setup do
            put :update, :id => @room.id, :room => Factory.attributes_for(:room)
          end
          should_set_the_flash_to 'Successfully updated room.'
          should_redirect_to('the room') { room_url(assigns(:room)) }
          should_assign_to(:room)
        end
        context 'given invalid parameters' do
          setup do
            put :update, :id => @room.id, :room => { :name => nil }
          end
          should_respond_with(:success)
          should_render_template(:edit)
          should_assign_to(:room)
        end
      end

      context 'on DELETE to :destroy' do
        setup do
          delete :destroy, :id => @room.id
        end
        should_set_the_flash_to 'Successfully destroyed room.'
        should_redirect_to('the room index') { rooms_url }
      end
    end
    
    context 'with read-only privileges' do
      setup do
        @user.remove_role('admin')
        @user.add_role('executive')
        @room = Factory(:room)
      end
      
      context 'on GET to :index' do
        setup do
          get :index
        end
        should_respond_with :success
        should_render_template(:index)
        should_assign_to(:rooms)
      end

      context 'on GET to :show' do
        context 'with existing room ID' do
          setup do
             get :show, :id => @room.id
          end
          should_respond_with :success
          should_render_template(:show)
          should_assign_to(:room)
        end
        context 'with non-existent room ID' do
          setup do
            get :show, :id => 0
          end
          should_set_the_flash_to "Couldn't find that room"
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
            post :create, :room => Factory.attributes_for(:room)
          end
          should_redirect_to('home page') { root_url }
        end
        context 'given invalid parameters' do
          setup do
            post :create, :room => { }
          end
          should_redirect_to('home page') { root_url }
        end
      end
      
      context 'on GET to :edit' do
        setup do
          get :edit, :id => @room.id
        end
        should_redirect_to('home page') { root_url }
      end
      
      context 'on PUT to :update' do
        context 'given valid parameters' do
          setup do
            put :update, :id => @room.id, :room => Factory.attributes_for(:room)
          end
          should_redirect_to('home page') { root_url }
        end
        context 'given invalid parameters' do
          setup do
            put :update, :id => @room.id, :room => { :name => nil }
          end
          should_redirect_to('home page') { root_url }
        end
      end

      context 'on DELETE to :destroy' do
        setup do
          delete :destroy, :id => @room.id
        end
        should_redirect_to('home page') { root_url }
      end
    end
  end
end
