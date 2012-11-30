require 'test_helper'

class AgentsControllerTest < ActionController::TestCase
  context 'The public' do
    setup do
      @agent = Factory(:agent)
    end

    context 'on API GET to :new' do
      setup do @request.env['HTTP_ACCEPT'] = 'application/xml'
        get :new
      end
      should_respond_with :success
      should_assign_to(:agent)
    end
    
    context 'on API PUT to :create' do
      setup do
        @request.env['HTTP_ACCEPT'] = 'application/xml'
        put :create, :id => @agent.id, :agent => Factory.attributes_for(:agent)
      end
      should_respond_with :success
      # TODO: check the XML response
#      should_render_template(:index)
      should_assign_to(:agent)
    end
  end
  
  context 'A signed-in, active user' do
    setup do
      @user = Factory(:email_confirmed_user)
      @user.activate
      @controller.current_user = @user
    end
  end
end
