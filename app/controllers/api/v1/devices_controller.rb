class Api::V1::DevicesController < ApplicationController
  protect_from_forgery with: :null_session

  # POST /devices
  # POST /devices.json
  def create
    @device = Device.find_by(device_token: device_params[:device_token])
    @device = Device.new if !@device

    @device.assign_attributes(device_params)

    if @device.save
      render '_device'
    else
      render json: @device.errors, status: :unprocessable_entity
    end
  end

  # DELETE /devices/1
  # DELETE /devices/1.json
  def destroy
    @device.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_device
      @device = Device.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def device_params
      params.require(:device).permit(:device_token, device_subscriptions_attributes: [:id, :subscribable_type, :subscribable_id, :_destroy])
    end
end
