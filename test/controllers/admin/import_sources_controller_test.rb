require "test_helper"

class Admin::ImportSourcesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @import_source = import_sources(:one)
  end

  test "should get index" do
    get admin_import_sources_url
    assert_response :success
  end

  test "should get new" do
    get new_admin_import_source_url
    assert_response :success
  end

  test "should create import_source" do
    assert_difference("ImportSource.count") do
      post admin_import_sources_url, params: { import_source: { gender_id: @import_source.gender_id, level_id: @import_source.level_id, name: @import_source.name, sport_id: @import_source.sport_id, url: @import_source.url } }
    end

    assert_redirected_to admin_import_source_url(ImportSource.last)
  end

  test "should show import_source" do
    get admin_import_source_url(@import_source)
    assert_response :success
  end

  test "should get edit" do
    get edit_admin_import_source_url(@import_source)
    assert_response :success
  end

  test "should update import_source" do
    patch admin_import_source_url(@import_source), params: { import_source: { gender_id: @import_source.gender_id, level_id: @import_source.level_id, name: @import_source.name, sport_id: @import_source.sport_id, url: @import_source.url } }
    assert_redirected_to admin_import_source_url(@import_source)
  end

  test "should destroy import_source" do
    assert_difference("ImportSource.count", -1) do
      delete admin_import_source_url(@import_source)
    end

    assert_redirected_to admin_import_sources_url
  end
end
