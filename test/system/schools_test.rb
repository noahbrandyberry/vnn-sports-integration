require "application_system_test_case"

class SchoolsTest < ApplicationSystemTestCase
  setup do
    @school = schools(:one)
  end

  test "visiting the index" do
    visit schools_url
    assert_selector "h1", text: "Schools"
  end

  test "should create school" do
    visit schools_url
    click_on "New school"

    fill_in "Athletic director", with: @school.athletic_director
    fill_in "Email", with: @school.email
    fill_in "Facebook url", with: @school.facebook_url
    fill_in "Instagram url", with: @school.instagram_url
    fill_in "Location", with: @school.location_id
    fill_in "Logo url", with: @school.logo_url
    fill_in "Mascot", with: @school.mascot
    fill_in "Name", with: @school.name
    fill_in "Phone", with: @school.phone
    fill_in "Primary color", with: @school.primary_color
    fill_in "Secondary color", with: @school.secondary_color
    fill_in "Tertiary color", with: @school.tertiary_color
    fill_in "Twitter url", with: @school.twitter_url
    fill_in "Url", with: @school.url
    click_on "Create School"

    assert_text "School was successfully created"
    click_on "Back"
  end

  test "should update School" do
    visit school_url(@school)
    click_on "Edit this school", match: :first

    fill_in "Athletic director", with: @school.athletic_director
    fill_in "Email", with: @school.email
    fill_in "Facebook url", with: @school.facebook_url
    fill_in "Instagram url", with: @school.instagram_url
    fill_in "Location", with: @school.location_id
    fill_in "Logo url", with: @school.logo_url
    fill_in "Mascot", with: @school.mascot
    fill_in "Name", with: @school.name
    fill_in "Phone", with: @school.phone
    fill_in "Primary color", with: @school.primary_color
    fill_in "Secondary color", with: @school.secondary_color
    fill_in "Tertiary color", with: @school.tertiary_color
    fill_in "Twitter url", with: @school.twitter_url
    fill_in "Url", with: @school.url
    click_on "Update School"

    assert_text "School was successfully updated"
    click_on "Back"
  end

  test "should destroy School" do
    visit school_url(@school)
    click_on "Destroy this school", match: :first

    assert_text "School was successfully destroyed"
  end
end
