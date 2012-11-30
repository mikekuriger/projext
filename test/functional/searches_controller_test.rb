require 'test_helper'

class SearchesControllerTest < ActionController::TestCase
  context 'The public' do
    context 'on GET to :index' do
      setup do
        get :index
      end
      should_redirect_to('home page') { root_url }
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
      end
      context 'on GET to :index' do

        context 'with valid query' do
          setup do
            get :index, :q => 'test'
          end
          should_respond_with :success
          should_render_template(:index)
          should_assign_to(:results)
        end
        
        context 'with no query' do
          setup do
            get :index
          end
          should_redirect_to('home page') { root_url }
        end
        
        context 'with blank query' do
          setup do
            get :index, :q => ''
          end
          should_respond_with :success
          should_render_template(:index)
          should_assign_to(:results)
        end
        
      end
    end
  end
end
