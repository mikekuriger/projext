require 'test_helper'

class QuotesControllerTest < ActionController::TestCase
  context 'The public' do
    setup do
      @quote = Factory(:quote)
    end
    context 'on GET to :index' do
      setup do
        get :index
      end
      should_redirect_to('sign-in page') { sign_in_url }
    end
    
    context 'on GET to :show' do
      context 'with existing quote ID' do
        setup do
          get :show, :id => @quote.id
        end
        should_redirect_to('sign-in page') { sign_in_url }
      end
      context 'with non-existent quote ID' do
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
        get :edit, :id => @quote.id
      end
      should_redirect_to('sign-in page') { sign_in_url }
    end

    context 'on POST to :create' do
      setup do
        post :create, :quote => Factory.attributes_for(:quote)
      end
      should_redirect_to('sign-in page') { sign_in_url }
    end

    context 'on PUT to :update' do
      setup do
        put :update, :id => @quote.id, :quote => Factory.attributes_for(:quote)
      end
      should_redirect_to('sign-in page') { sign_in_url }
    end

    context 'on DELETE to :destroy' do
      setup do
        delete :destroy, :id => @quote.id
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
        @quote = Factory(:quote)
      end

      context 'on GET to :index' do
        setup do
          get :index
        end
        should_respond_with :success
        should_render_template(:index)
        should_assign_to(:quotes)
      end
      
      context 'on GET to :show' do
        context 'with existing quote ID' do
          setup do
             get :show, :id => @quote.id
          end
          should_respond_with :success
          should_render_template(:show)
          should_assign_to(:quote)
        end
        context 'with non-existant quote ID' do
          setup do
            get :show, :id => 0
          end
          should_set_the_flash_to "Couldn't find that quote"
          should_redirect_to('home page') { root_url }
        end
      end
      
      context 'on GET to :new' do
        setup do
          get :new
        end
        should_respond_with(:success)
        should_render_template(:new)
        should_assign_to(:quote)
      end
      
      context 'on POST to :create' do
        context 'given valid parameters' do
          setup do
            post :create, :quote => Factory.attributes_for(:quote)
          end
          should_set_the_flash_to 'Successfully created quote.'
          should_redirect_to('the quote') { quote_url(assigns(:quote)) }
        end
        context 'given invalid parameters' do
          setup do
            post :create, :quote => { }
          end
          should_respond_with(:success)
          should_render_template(:new)
        end
      end
      
      context 'on GET to :edit' do
        setup do
          get :edit, :id => @quote.id
        end
        should_respond_with(:success)
        should_render_template(:edit)
        should_assign_to(:quote)
      end
      
      context 'on PUT to :update' do
        context 'given valid parameters' do
          setup do
            put :update, :id => @quote.id, :quote => Factory.attributes_for(:quote)
          end
          should_set_the_flash_to 'Successfully updated quote.'
          should_redirect_to('the quote') { quote_url(assigns(:quote)) }
          should_assign_to(:quote)
        end
        context 'given invalid parameters' do
          setup do
            put :update, :id => @quote.id, :quote => { :name => nil }
          end
          should_respond_with(:success)
          should_render_template(:edit)
          should_assign_to(:quote)
        end
      end

      context 'on DELETE to :destroy' do
        setup do
          delete :destroy, :id => @quote.id
        end
        should_set_the_flash_to 'Successfully destroyed quote.'
        should_redirect_to('the quote index') { quotes_url }
      end
    end
    
    context 'with read-only privileges' do
      setup do
        @user.remove_role('admin')
        @user.add_role('executive')
        @quote = Factory(:quote)
      end
      
      context 'on GET to :index' do
        setup do
          get :index
        end
        should_respond_with :success
        should_render_template(:index)
        should_assign_to(:quotes)
      end

      context 'on GET to :show' do
        context 'with existing quote ID' do
          setup do
             get :show, :id => @quote.id
          end
          should_respond_with :success
          should_render_template(:show)
          should_assign_to(:quote)
        end
        context 'with non-existent quote ID' do
          setup do
            get :show, :id => 0
          end
          should_set_the_flash_to "Couldn't find that quote"
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
            post :create, :quote => Factory.attributes_for(:quote)
          end
          should_redirect_to('home page') { root_url }
        end
        context 'given invalid parameters' do
          setup do
            post :create, :quote => { }
          end
          should_redirect_to('home page') { root_url }
        end
      end
      
      context 'on GET to :edit' do
        setup do
          get :edit, :id => @quote.id
        end
        should_redirect_to('home page') { root_url }
      end
      
      context 'on PUT to :update' do
        context 'given valid parameters' do
          setup do
            put :update, :id => @quote.id, :quote => Factory.attributes_for(:quote)
          end
          should_redirect_to('home page') { root_url }
        end
        context 'given invalid parameters' do
          setup do
            put :update, :id => @quote.id, :quote => { :name => nil }
          end
          should_redirect_to('home page') { root_url }
        end
      end

      context 'on DELETE to :destroy' do
        setup do
          delete :destroy, :id => @quote.id
        end
        should_redirect_to('home page') { root_url }
      end
    end
  end
end
