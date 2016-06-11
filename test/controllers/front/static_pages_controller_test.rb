require 'test_helper'

class Front::StaticPagesControllerTest < ActionController::TestCase
  test "should get home" do
    get :home
    assert_response :success
  end

  test "should get learn_more" do
    get :learn_more
    assert_response :success
  end

end
