require 'test_helper'

class PortsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => Port.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    Port.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    Port.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to port_url(assigns(:port))
  end
  
  def test_edit
    get :edit, :id => Port.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    Port.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Port.first
    assert_template 'edit'
  end
  
  def test_update_valid
    Port.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Port.first
    assert_redirected_to port_url(assigns(:port))
  end
  
  def test_destroy
    port = Port.first
    delete :destroy, :id => port
    assert_redirected_to ports_url
    assert !Port.exists?(port.id)
  end
end
