require 'test_helper'

class MypageControllerTest < ActionDispatch::IntegrationTest
  test "should get my_channels" do
    get mypage_my_channels_url
    assert_response :success
  end

  test "should get contributed" do
    get mypage_contributed_url
    assert_response :success
  end

  test "should get watched" do
    get mypage_watched_url
    assert_response :success
  end

end
