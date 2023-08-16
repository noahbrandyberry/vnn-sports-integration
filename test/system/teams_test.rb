require "application_system_test_case"

class TeamsTest < ApplicationSystemTestCase
  setup do
    @team = teams(:one)
  end

  test "visiting the index" do
    visit teams_url
    assert_selector "h1", text: "Teams"
  end

  test "should create team" do
    visit teams_url
    click_on "New team"

    check "Hide gender" if @team.hide_gender
    fill_in "Home description", with: @team.home_description
    fill_in "Label", with: @team.label
    fill_in "Level", with: @team.level_id
    fill_in "Name", with: @team.name
    fill_in "Photo url", with: @team.photo_url
    fill_in "Program", with: @team.program_id
    fill_in "Season", with: @team.season_id
    fill_in "Year", with: @team.year_id
    click_on "Create Team"

    assert_text "Team was successfully created"
    click_on "Back"
  end

  test "should update Team" do
    visit team_url(@team)
    click_on "Edit this team", match: :first

    check "Hide gender" if @team.hide_gender
    fill_in "Home description", with: @team.home_description
    fill_in "Label", with: @team.label
    fill_in "Level", with: @team.level_id
    fill_in "Name", with: @team.name
    fill_in "Photo url", with: @team.photo_url
    fill_in "Program", with: @team.program_id
    fill_in "Season", with: @team.season_id
    fill_in "Year", with: @team.year_id
    click_on "Update Team"

    assert_text "Team was successfully updated"
    click_on "Back"
  end

  test "should destroy Team" do
    visit team_url(@team)
    click_on "Destroy this team", match: :first

    assert_text "Team was successfully destroyed"
  end
end
