require 'test_helper'

class MyfandomsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @myfandom = myfandoms(:one)
  end

  test "should get index" do
    get myfandoms_url
    assert_response :success
  end

  test "should get new" do
    get new_myfandom_url
    assert_response :success
  end

  test "should create myfandom" do
    assert_difference('Myfandom.count') do
      post myfandoms_url, params: { myfandom: { fandom_id: @myfandom.fandom_id, user_id: @myfandom.user_id } }
    end

    assert_redirected_to myfandom_url(Myfandom.last)
  end

  test "should show myfandom" do
    get myfandom_url(@myfandom)
    assert_response :success
  end

  test "should get edit" do
    get edit_myfandom_url(@myfandom)
    assert_response :success
  end

  test "should update myfandom" do
    patch myfandom_url(@myfandom), params: { myfandom: { fandom_id: @myfandom.fandom_id, user_id: @myfandom.user_id } }
    assert_redirected_to myfandom_url(@myfandom)
  end

  test "should destroy myfandom" do
    assert_difference('Myfandom.count', -1) do
      delete myfandom_url(@myfandom)
    end

    assert_redirected_to myfandoms_url
  end
end
