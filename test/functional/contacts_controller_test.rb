require 'test_helper'

class ContactsControllerTest < ActionController::TestCase
  context 'The public' do
    setup do
      @contact = Factory(:contact)
    end
    context 'on GET to :index' do
      setup do
        get :index
      end
      should_redirect_to('sign-in page') { sign_in_url }
    end
    
    context 'on GET to :show' do
      context 'with existing contact ID' do
        setup do
          get :show, :id => @contact.id
        end
        should_redirect_to('sign-in page') { sign_in_url }
      end
      context 'with non-existent contact ID' do
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
        get :edit, :id => @contact.id
      end
      should_redirect_to('sign-in page') { sign_in_url }
    end

    context 'on POST to :create' do
      setup do
        post :create, :contact => Factory.attributes_for(:contact)
      end
      should_redirect_to('sign-in page') { sign_in_url }
    end

    context 'on PUT to :update' do
      setup do
        put :update, :id => @contact.id, :contact => Factory.attributes_for(:contact)
      end
      should_redirect_to('sign-in page') { sign_in_url }
    end

    context 'on DELETE to :destroy' do
      setup do
        delete :destroy, :id => @contact.id
      end
      should_redirect_to('sign-in page') { sign_in_url }
    end
    
  end
  
  context 'A signed-in user' do
    setup do
      @user = Factory(:email_confirmed_user)
      @controller.current_user = @user
    end
    
    context 'with admin privileges' do
      setup do
        @user.add_role('admin')
        @contact = Factory(:contact)
      end

      context 'on GET to :index' do
        setup do
          get :index
        end
        should_respond_with :success
        should_render_template(:index)
        should_assign_to(:contacts)
      end
      
      context 'on GET to :show' do
        context 'with existing contact ID' do
          setup do
             get :show, :id => @contact.id
          end
          should_respond_with :success
          should_render_template(:show)
          should_assign_to(:contact)
        end
        context 'with non-existant contact ID' do
          setup do
            get :show, :id => 0
          end
          should_set_the_flash_to "Couldn't find that contact"
          should_redirect_to('home page') { root_url }
        end
      end
      
      context 'on GET to :new' do
        setup do
          get :new
        end
        should_respond_with(:success)
        should_render_template(:new)
        should_assign_to(:contact)
      end
      
      context 'on POST to :create' do
        context 'given valid parameters' do
          setup do
            post :create, :contact => Factory.attributes_for(:contact)
          end
          should_set_the_flash_to 'Successfully created contact.'
          should_redirect_to('the contact') { contact_url(assigns(:contact)) }
        end
        context 'given invalid parameters' do
          setup do
            post :create, :contact => { }
          end
          should_respond_with(:success)
          should_render_template(:new)
        end
      end
      
      context 'on GET to :edit' do
        setup do
          get :edit, :id => @contact.id
        end
        should_respond_with(:success)
        should_render_template(:edit)
        should_assign_to(:contact)
      end
      
      context 'on PUT to :update' do
        context 'given valid parameters' do
          setup do
            put :update, :id => @contact.id, :contact => Factory.attributes_for(:contact)
          end
          should_set_the_flash_to 'Successfully updated contact.'
          should_redirect_to('the contact') { contact_url(assigns(:contact)) }
          should_assign_to(:contact)
        end
        context 'given invalid parameters' do
          setup do
            put :update, :id => @contact.id, :contact => { :name => nil }
          end
          should_respond_with(:success)
          should_render_template(:edit)
          should_assign_to(:contact)
        end
      end

      context 'on DELETE to :destroy' do
        setup do
          delete :destroy, :id => @contact.id
        end
        should_set_the_flash_to 'Successfully destroyed contact.'
        should_redirect_to('the contact index') { contacts_url }
      end
    end
    
    context 'with read-only privileges' do
      setup do
        @user.remove_role('admin')
        @user.add_role('executive')
        @contact = Factory(:contact)
      end
      
      context 'on GET to :index' do
        setup do
          get :index
        end
        should_respond_with :success
        should_render_template(:index)
        should_assign_to(:contacts)
      end

      context 'on GET to :show' do
        context 'with existing contact ID' do
          setup do
             get :show, :id => @contact.id
          end
          should_respond_with :success
          should_render_template(:show)
          should_assign_to(:contact)
        end
        context 'with non-existent contact ID' do
          setup do
            get :show, :id => 0
          end
          should_set_the_flash_to "Couldn't find that contact"
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
            post :create, :contact => Factory.attributes_for(:contact)
          end
          should_redirect_to('home page') { root_url }
        end
        context 'given invalid parameters' do
          setup do
            post :create, :contact => { }
          end
          should_redirect_to('home page') { root_url }
        end
      end
      
      context 'on GET to :edit' do
        setup do
          get :edit, :id => @contact.id
        end
        should_redirect_to('home page') { root_url }
      end
      
      context 'on PUT to :update' do
        context 'given valid parameters' do
          setup do
            put :update, :id => @contact.id, :contact => Factory.attributes_for(:contact)
          end
          should_redirect_to('home page') { root_url }
        end
        context 'given invalid parameters' do
          setup do
            put :update, :id => @contact.id, :contact => { :name => nil }
          end
          should_redirect_to('home page') { root_url }
        end
      end

      context 'on DELETE to :destroy' do
        setup do
          delete :destroy, :id => @contact.id
        end
        should_redirect_to('home page') { root_url }
      end
    end
  end

end
