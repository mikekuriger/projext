require 'test_helper'

class NetworkingDevicesControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => NetworkingDevice.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    NetworkingDevice.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    NetworkingDevice.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to networking_device_url(assigns(:networking_device))
  end
  
  def test_edit
    get :edit, :id => NetworkingDevice.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    NetworkingDevice.any_instance.stubs(:valid?).returns(false)
    put :update, :id => NetworkingDevice.first
    assert_template 'edit'
  end
  
  def test_update_valid
    NetworkingDevice.any_instance.stubs(:valid?).returns(true)
    put :update, :id => NetworkingDevice.first
    assert_redirected_to networking_device_url(assigns(:networking_device))
  end
  
  def test_destroy
    networking_device = NetworkingDevice.first
    delete :destroy, :id => networking_device
    assert_redirected_to networking_devices_url
    assert !NetworkingDevice.exists?(networking_device.id)
  end
end
