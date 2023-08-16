require "test_helper"

class Admin::SchoolsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @school = schools(:one)
  end

  test "should get index" do
    get admin_schools_url
    assert_response :success
  end

  test "should get new" do
    get new_admin_school_url
    assert_response :success
  end

  test "should create school" do
    assert_difference("School.count") do
      post admin_schools_url, params: { school: { athletic_director: @school.athletic_director, email: @school.email, facebook_url: @school.facebook_url, instagram_url: @school.instagram_url, location_id: @school.location_id, logo_url: @school.logo_url, mascot: @school.mascot, name: @school.name, phone: @school.phone, primary_color: @school.primary_color, secondary_color: @school.secondary_color, tertiary_color: @school.tertiary_color, twitter_url: @school.twitter_url, url: @school.url } }
    end

    assert_redirected_to admin_school_url(School.last)
  end

  test "should show school" do
    get admin_school_url(@school)
    assert_response :success
  end

  test "should get edit" do
    get edit_admin_school_url(@school)
    assert_response :success
  end

  test "should update school" do
    patch admin_school_url(@school), params: { school: { athletic_director: @school.athletic_director, email: @school.email, facebook_url: @school.facebook_url, instagram_url: @school.instagram_url, location_id: @school.location_id, logo_url: @school.logo_url, mascot: @school.mascot, name: @school.name, phone: @school.phone, primary_color: @school.primary_color, secondary_color: @school.secondary_color, tertiary_color: @school.tertiary_color, twitter_url: @school.twitter_url, url: @school.url } }
    assert_redirected_to admin_school_url(@school)
  end

  test "should destroy school" do
    assert_difference("School.count", -1) do
      delete admin_school_url(@school)
    end

    assert_redirected_to admin_schools_url
  end
end
