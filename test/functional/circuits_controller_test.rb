require 'test_helper'

class CircuitsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => Circuit.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    Circuit.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    Circuit.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to circuit_url(assigns(:circuit))
  end
  
  def test_edit
    get :edit, :id => Circuit.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    Circuit.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Circuit.first
    assert_template 'edit'
  end
  
  def test_update_valid
    Circuit.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Circuit.first
    assert_redirected_to circuit_url(assigns(:circuit))
  end
  
  def test_destroy
    circuit = Circuit.first
    delete :destroy, :id => circuit
    assert_redirected_to circuits_url
    assert !Circuit.exists?(circuit.id)
  end
end
