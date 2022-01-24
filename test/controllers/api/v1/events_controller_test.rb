require "test_helper"

class Api::V1::EventsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @event = events(:one)
  end

  test "should get index" do
    get api_v1_events_url, as: :json
    assert_response :success
  end

  test "should create event" do
    assert_difference("Event.count") do
      post api_v1_events_url, params: { event: { bus_departure_datetime_local: @event.bus_departure_datetime_local, bus_dismissal_datetime_local: @event.bus_dismissal_datetime_local, bus_return_datetime_local: @event.bus_return_datetime_local, canceled: @event.canceled, conference: @event.conference, event_type: @event.event_type, home: @event.home, host_team_id: @event.host_team_id, location_id: @event.location_id, location_verified: @event.location_verified, name: @event.name, postponed: @event.postponed, private_notes: @event.private_notes, public_notes: @event.public_notes, result_type: @event.result_type, scrimmage: @event.scrimmage, start: @event.start, tba: @event.tba } }, as: :json
    end

    assert_response :created
  end

  test "should show event" do
    get api_v1_event_url(@event), as: :json
    assert_response :success
  end

  test "should update event" do
    patch api_v1_event_url(@event), params: { event: { bus_departure_datetime_local: @event.bus_departure_datetime_local, bus_dismissal_datetime_local: @event.bus_dismissal_datetime_local, bus_return_datetime_local: @event.bus_return_datetime_local, canceled: @event.canceled, conference: @event.conference, event_type: @event.event_type, home: @event.home, host_team_id: @event.host_team_id, location_id: @event.location_id, location_verified: @event.location_verified, name: @event.name, postponed: @event.postponed, private_notes: @event.private_notes, public_notes: @event.public_notes, result_type: @event.result_type, scrimmage: @event.scrimmage, start: @event.start, tba: @event.tba } }, as: :json
    assert_response :success
  end

  test "should destroy event" do
    assert_difference("Event.count", -1) do
      delete api_v1_event_url(@event), as: :json
    end

    assert_response :no_content
  end
end
