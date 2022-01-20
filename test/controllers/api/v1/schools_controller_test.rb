require "test_helper"

class Api::V1::SchoolsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @school = schools(:one)
  end

  test "should get index" do
    get api_v1_schools_url, as: :json
    assert_response :success
  end

  test "should create school" do
    assert_difference("School.count") do
      post api_v1_schools_url, params: { school: { anti_discrimination_disclaimer: @school.anti_discrimination_disclaimer, athletic_director: @school.athletic_director, blog: @school.blog, email: @school.email, enrollment: @school.enrollment, instagram: @school.instagram, is_vnn: @school.is_vnn, logo_url: @school.logo_url, mascot: @school.mascot, name: @school.name, onboarding: @school.onboarding, phone: @school.phone, primary_color: @school.primary_color, registration_text: @school.registration_text, registration_url: @school.registration_url, secondary_color: @school.secondary_color, sportshub_version: @school.sportshub_version, tertiary_color: @school.tertiary_color, url: @school.url, version: @school.version } }, as: :json
    end

    assert_response :created
  end

  test "should show school" do
    get api_v1_school_url(@school), as: :json
    assert_response :success
  end

  test "should update school" do
    patch api_v1_school_url(@school), params: { school: { anti_discrimination_disclaimer: @school.anti_discrimination_disclaimer, athletic_director: @school.athletic_director, blog: @school.blog, email: @school.email, enrollment: @school.enrollment, instagram: @school.instagram, is_vnn: @school.is_vnn, logo_url: @school.logo_url, mascot: @school.mascot, name: @school.name, onboarding: @school.onboarding, phone: @school.phone, primary_color: @school.primary_color, registration_text: @school.registration_text, registration_url: @school.registration_url, secondary_color: @school.secondary_color, sportshub_version: @school.sportshub_version, tertiary_color: @school.tertiary_color, url: @school.url, version: @school.version } }, as: :json
    assert_response :success
  end

  test "should destroy school" do
    assert_difference("School.count", -1) do
      delete api_v1_school_url(@school), as: :json
    end

    assert_response :no_content
  end
end
