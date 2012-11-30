require 'test_helper'

class FirewallsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => Firewall.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    Firewall.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    Firewall.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to firewall_url(assigns(:firewall))
  end
  
  def test_edit
    get :edit, :id => Firewall.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    Firewall.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Firewall.first
    assert_template 'edit'
  end
  
  def test_update_valid
    Firewall.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Firewall.first
    assert_redirected_to firewall_url(assigns(:firewall))
  end
  
  def test_destroy
    firewall = Firewall.first
    delete :destroy, :id => firewall
    assert_redirected_to firewalls_url
    assert !Firewall.exists?(firewall.id)
  end
end
