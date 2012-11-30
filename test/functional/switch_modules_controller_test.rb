require 'test_helper'

class SwitchModulesControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => SwitchModule.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    SwitchModule.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    SwitchModule.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to switch_module_url(assigns(:switch_module))
  end
  
  def test_edit
    get :edit, :id => SwitchModule.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    SwitchModule.any_instance.stubs(:valid?).returns(false)
    put :update, :id => SwitchModule.first
    assert_template 'edit'
  end
  
  def test_update_valid
    SwitchModule.any_instance.stubs(:valid?).returns(true)
    put :update, :id => SwitchModule.first
    assert_redirected_to switch_module_url(assigns(:switch_module))
  end
  
  def test_destroy
    switch_module = SwitchModule.first
    delete :destroy, :id => switch_module
    assert_redirected_to switch_modules_url
    assert !SwitchModule.exists?(switch_module.id)
  end
end
