require 'test_helper'

class DiagramsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => Diagram.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    Diagram.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    Diagram.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to diagram_url(assigns(:diagram))
  end
  
  def test_edit
    get :edit, :id => Diagram.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    Diagram.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Diagram.first
    assert_template 'edit'
  end
  
  def test_update_valid
    Diagram.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Diagram.first
    assert_redirected_to diagram_url(assigns(:diagram))
  end
  
  def test_destroy
    diagram = Diagram.first
    delete :destroy, :id => diagram
    assert_redirected_to diagrams_url
    assert !Diagram.exists?(diagram.id)
  end
end
