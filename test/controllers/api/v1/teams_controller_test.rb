require "test_helper"

class Api::V1::TeamsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @team = teams(:one)
  end

  test "should get index" do
    get api_v1_teams_url, as: :json
    assert_response :success
  end

  test "should create team" do
    assert_difference("Team.count") do
      post api_v1_teams_url, params: { team: { hide_gender: @team.hide_gender, home_description: @team.home_description, label: @team.label, name: @team.name, photo_url: @team.photo_url } }, as: :json
    end

    assert_response :created
  end

  test "should show team" do
    get api_v1_team_url(@team), as: :json
    assert_response :success
  end

  test "should update team" do
    patch api_v1_team_url(@team), params: { team: { hide_gender: @team.hide_gender, home_description: @team.home_description, label: @team.label, name: @team.name, photo_url: @team.photo_url } }, as: :json
    assert_response :success
  end

  test "should destroy team" do
    assert_difference("Team.count", -1) do
      delete api_v1_team_url(@team), as: :json
    end

    assert_response :no_content
  end
end
