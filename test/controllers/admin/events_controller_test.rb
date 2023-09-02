require "test_helper"

class Admin::EventsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @event = events(:one)
  end

  test "should get index" do
    get admin_events_url
    assert_response :success
  end

  test "should get new" do
    get new_admin_event_url
    assert_response :success
  end

  test "should create event" do
    assert_difference("Event.count") do
      post admin_events_url, params: { event: { location_id: @event.location_id, location_name: @event.location_name, name: @event.name, start: @event.start } }
    end

    assert_redirected_to admin_event_url(Event.last)
  end

  test "should show event" do
    get admin_event_url(@event)
    assert_response :success
  end

  test "should get edit" do
    get edit_admin_event_url(@event)
    assert_response :success
  end

  test "should update event" do
    patch admin_event_url(@event), params: { event: { location_id: @event.location_id, location_name: @event.location_name, name: @event.name, start: @event.start } }
    assert_redirected_to admin_event_url(@event)
  end

  test "should destroy event" do
    assert_difference("Event.count", -1) do
      delete admin_event_url(@event)
    end

    assert_redirected_to admin_events_url
  end
end
