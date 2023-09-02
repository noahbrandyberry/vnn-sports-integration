require "test_helper"

class Admin::PlayersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @player = players(:one)
  end

  test "should get index" do
    get admin_players_url
    assert_response :success
  end

  test "should get new" do
    get new_admin_player_url
    assert_response :success
  end

  test "should create player" do
    assert_difference("Player.count") do
      post admin_players_url, params: { player: { first_name: @player.first_name, grad_year: @player.grad_year, height: @player.height, jersey: @player.jersey, last_name: @player.last_name, position: @player.position, weight: @player.weight } }
    end

    assert_redirected_to admin_player_url(Player.last)
  end

  test "should show player" do
    get admin_player_url(@player)
    assert_response :success
  end

  test "should get edit" do
    get edit_admin_player_url(@player)
    assert_response :success
  end

  test "should update player" do
    patch admin_player_url(@player), params: { player: { first_name: @player.first_name, grad_year: @player.grad_year, height: @player.height, jersey: @player.jersey, last_name: @player.last_name, position: @player.position, weight: @player.weight } }
    assert_redirected_to admin_player_url(@player)
  end

  test "should destroy player" do
    assert_difference("Player.count", -1) do
      delete admin_player_url(@player)
    end

    assert_redirected_to admin_players_url
  end
end
