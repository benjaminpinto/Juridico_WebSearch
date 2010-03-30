require 'test_helper'

class ReclamantesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:reclamantes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create reclamante" do
    assert_difference('Reclamante.count') do
      post :create, :reclamante => { }
    end

    assert_redirected_to reclamante_path(assigns(:reclamante))
  end

  test "should show reclamante" do
    get :show, :id => reclamantes(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => reclamantes(:one).to_param
    assert_response :success
  end

  test "should update reclamante" do
    put :update, :id => reclamantes(:one).to_param, :reclamante => { }
    assert_redirected_to reclamante_path(assigns(:reclamante))
  end

  test "should destroy reclamante" do
    assert_difference('Reclamante.count', -1) do
      delete :destroy, :id => reclamantes(:one).to_param
    end

    assert_redirected_to reclamantes_path
  end
end
