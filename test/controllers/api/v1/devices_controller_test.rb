require "test_helper"

class Api::V1::DevicesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @device = devices(:one)
  end

  test "should get index" do
    get api_v1_devices_url, as: :json
    assert_response :success
  end

  test "should create device" do
    assert_difference("Device.count") do
      post api_v1_devices_url, params: { device: { device_token: @device.device_token } }, as: :json
    end

    assert_response :created
  end

  test "should show device" do
    get api_v1_device_url(@device), as: :json
    assert_response :success
  end

  test "should update device" do
    patch api_v1_device_url(@device), params: { device: { device_token: @device.device_token } }, as: :json
    assert_response :success
  end

  test "should destroy device" do
    assert_difference("Device.count", -1) do
      delete api_v1_device_url(@device), as: :json
    end

    assert_response :no_content
  end
end
