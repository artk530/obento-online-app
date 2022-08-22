require 'test_helper'

class OrdersControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get order_new_url
    assert_response :success
  end

  test "should get check" do
    get order_check_url
    assert_response :success
  end

  test "should get create" do
    get order_create_url
    assert_response :success
  end

end
