require 'test_helper'

class LoadBalancersControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => LoadBalancer.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    LoadBalancer.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    LoadBalancer.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to load_balancer_url(assigns(:load_balancer))
  end
  
  def test_edit
    get :edit, :id => LoadBalancer.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    LoadBalancer.any_instance.stubs(:valid?).returns(false)
    put :update, :id => LoadBalancer.first
    assert_template 'edit'
  end
  
  def test_update_valid
    LoadBalancer.any_instance.stubs(:valid?).returns(true)
    put :update, :id => LoadBalancer.first
    assert_redirected_to load_balancer_url(assigns(:load_balancer))
  end
  
  def test_destroy
    load_balancer = LoadBalancer.first
    delete :destroy, :id => load_balancer
    assert_redirected_to load_balancers_url
    assert !LoadBalancer.exists?(load_balancer.id)
  end
end
