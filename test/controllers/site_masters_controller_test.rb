require 'test_helper'

class SiteMastersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @site_master = site_masters(:one)
  end

  test "should get index" do
    get site_masters_url
    assert_response :success
  end

  test "should get new" do
    get new_site_master_url
    assert_response :success
  end

  test "should create site_master" do
    assert_difference('SiteMaster.count') do
      post site_masters_url, params: { site_master: { fandom_publish_count: @site_master.fandom_publish_count, message_global_error: @site_master.message_global_error, message_login_please: @site_master.message_login_please } }
    end

    assert_redirected_to site_master_url(SiteMaster.last)
  end

  test "should show site_master" do
    get site_master_url(@site_master)
    assert_response :success
  end

  test "should get edit" do
    get edit_site_master_url(@site_master)
    assert_response :success
  end

  test "should update site_master" do
    patch site_master_url(@site_master), params: { site_master: { fandom_publish_count: @site_master.fandom_publish_count, message_global_error: @site_master.message_global_error, message_login_please: @site_master.message_login_please } }
    assert_redirected_to site_master_url(@site_master)
  end

  test "should destroy site_master" do
    assert_difference('SiteMaster.count', -1) do
      delete site_master_url(@site_master)
    end

    assert_redirected_to site_masters_url
  end
end
