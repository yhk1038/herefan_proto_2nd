require 'test_helper'

class ConsoleControllerTest < ActionDispatch::IntegrationTest
  test "should get setting_planet" do
    get console_setting_planet_url
    assert_response :success
  end

  test "should get admin" do
    get console_admin_url
    assert_response :success
  end

  test "should get site_config" do
    get console_site_config_url
    assert_response :success
  end

  test "should get debug" do
    get console_debug_url
    assert_response :success
  end

end
