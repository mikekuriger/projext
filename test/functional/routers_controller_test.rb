require 'test_helper'

class RoutersControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => Router.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    Router.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    Router.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to router_url(assigns(:router))
  end
  
  def test_edit
    get :edit, :id => Router.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    Router.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Router.first
    assert_template 'edit'
  end
  
  def test_update_valid
    Router.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Router.first
    assert_redirected_to router_url(assigns(:router))
  end
  
  def test_destroy
    router = Router.first
    delete :destroy, :id => router
    assert_redirected_to routers_url
    assert !Router.exists?(router.id)
  end
end
