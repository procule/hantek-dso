require 'test_helper'

class MacsControllerTest < ActionController::TestCase
  setup do
    @mac = macs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:macs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create mac" do
    assert_difference('Mac.count') do
      post :create, mac: { address: @mac.address }
    end

    assert_redirected_to mac_path(assigns(:mac))
  end

  test "should show mac" do
    get :show, id: @mac
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @mac
    assert_response :success
  end

  test "should update mac" do
    patch :update, id: @mac, mac: { address: @mac.address }
    assert_redirected_to mac_path(assigns(:mac))
  end

  test "should destroy mac" do
    assert_difference('Mac.count', -1) do
      delete :destroy, id: @mac
    end

    assert_redirected_to macs_path
  end
end
