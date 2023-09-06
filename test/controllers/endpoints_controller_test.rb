require "test_helper"

class EndpointsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get endpoints_index_url
    assert_response :success
  end

  test "should get show" do
    get endpoints_show_url
    assert_response :success
  end

  test "should get new" do
    get endpoints_new_url
    assert_response :success
  end

  test "should get create" do
    get endpoints_create_url
    assert_response :success
  end

  test "should get edit" do
    get endpoints_edit_url
    assert_response :success
  end

  test "should get update" do
    get endpoints_update_url
    assert_response :success
  end
end
