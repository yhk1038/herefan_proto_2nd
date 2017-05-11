require 'test_helper'

class HfUtilControllerTest < ActionDispatch::IntegrationTest
  test "should get user_must_have_unique_myfandom" do
    get hf_util_user_must_have_unique_myfandom_url
    assert_response :success
  end

end
