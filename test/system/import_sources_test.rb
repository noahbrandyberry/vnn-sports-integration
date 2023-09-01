require "application_system_test_case"

class ImportSourcesTest < ApplicationSystemTestCase
  setup do
    @import_source = import_sources(:one)
  end

  test "visiting the index" do
    visit import_sources_url
    assert_selector "h1", text: "Import sources"
  end

  test "should create import source" do
    visit import_sources_url
    click_on "New import source"

    fill_in "Gender", with: @import_source.gender_id
    fill_in "Level", with: @import_source.level_id
    fill_in "Name", with: @import_source.name
    fill_in "Sport", with: @import_source.sport_id
    fill_in "Url", with: @import_source.url
    click_on "Create Import source"

    assert_text "Import source was successfully created"
    click_on "Back"
  end

  test "should update Import source" do
    visit import_source_url(@import_source)
    click_on "Edit this import source", match: :first

    fill_in "Gender", with: @import_source.gender_id
    fill_in "Level", with: @import_source.level_id
    fill_in "Name", with: @import_source.name
    fill_in "Sport", with: @import_source.sport_id
    fill_in "Url", with: @import_source.url
    click_on "Update Import source"

    assert_text "Import source was successfully updated"
    click_on "Back"
  end

  test "should destroy Import source" do
    visit import_source_url(@import_source)
    click_on "Destroy this import source", match: :first

    assert_text "Import source was successfully destroyed"
  end
end
