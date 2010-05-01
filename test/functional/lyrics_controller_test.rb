require 'test_helper'

class LyricsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:lyrics)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create lyric" do
    assert_difference('Lyric.count') do
      post :create, :lyric => { }
    end

    assert_redirected_to lyric_path(assigns(:lyric))
  end

  test "should show lyric" do
    get :show, :id => lyrics(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => lyrics(:one).id
    assert_response :success
  end

  test "should update lyric" do
    put :update, :id => lyrics(:one).id, :lyric => { }
    assert_redirected_to lyric_path(assigns(:lyric))
  end

  test "should destroy lyric" do
    assert_difference('Lyric.count', -1) do
      delete :destroy, :id => lyrics(:one).id
    end

    assert_redirected_to lyrics_path
  end
end
