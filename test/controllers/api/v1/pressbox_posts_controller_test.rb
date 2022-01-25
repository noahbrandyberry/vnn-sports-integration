require "test_helper"

class Api::V1::PressboxPostsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @pressbox_post = pressbox_posts(:one)
  end

  test "should get index" do
    get api_v1_pressbox_posts_url, as: :json
    assert_response :success
  end

  test "should create pressbox_post" do
    assert_difference("PressboxPost.count") do
      post api_v1_pressbox_posts_url, params: { pressbox_post: { boxscore: @pressbox_post.boxscore, created: @pressbox_post.created, created_by: @pressbox_post.created_by, featured_image: @pressbox_post.featured_image, is_visible: @pressbox_post.is_visible, modified: @pressbox_post.modified, modified_by: @pressbox_post.modified_by, recap: @pressbox_post.recap, submitted: @pressbox_post.submitted, submitted_by: @pressbox_post.submitted_by, title: @pressbox_post.title, website_only: @pressbox_post.website_only } }, as: :json
    end

    assert_response :created
  end

  test "should show pressbox_post" do
    get api_v1_pressbox_post_url(@pressbox_post), as: :json
    assert_response :success
  end

  test "should update pressbox_post" do
    patch api_v1_pressbox_post_url(@pressbox_post), params: { pressbox_post: { boxscore: @pressbox_post.boxscore, created: @pressbox_post.created, created_by: @pressbox_post.created_by, featured_image: @pressbox_post.featured_image, is_visible: @pressbox_post.is_visible, modified: @pressbox_post.modified, modified_by: @pressbox_post.modified_by, recap: @pressbox_post.recap, submitted: @pressbox_post.submitted, submitted_by: @pressbox_post.submitted_by, title: @pressbox_post.title, website_only: @pressbox_post.website_only } }, as: :json
    assert_response :success
  end

  test "should destroy pressbox_post" do
    assert_difference("PressboxPost.count", -1) do
      delete api_v1_pressbox_post_url(@pressbox_post), as: :json
    end

    assert_response :no_content
  end
end
