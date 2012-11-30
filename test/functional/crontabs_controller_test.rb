require 'test_helper'

class CrontabsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:crontabs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create crontab" do
    assert_difference('Crontab.count') do
      post :create, :crontab => { }
    end

    assert_redirected_to crontab_path(assigns(:crontab))
  end

  test "should show crontab" do
    get :show, :id => crontabs(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => crontabs(:one).to_param
    assert_response :success
  end

  test "should update crontab" do
    put :update, :id => crontabs(:one).to_param, :crontab => { }
    assert_redirected_to crontab_path(assigns(:crontab))
  end

  test "should destroy crontab" do
    assert_difference('Crontab.count', -1) do
      delete :destroy, :id => crontabs(:one).to_param
    end

    assert_redirected_to crontabs_path
  end
end
