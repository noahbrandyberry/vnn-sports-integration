class Api::V1::DevicesController < ApplicationController
  protect_from_forgery with: :null_session

  # POST /devices
  # POST /devices.json
  def create
    @device = Device.find_by(device_params)
    @device = Device.new(device_params) if !@device

    if @device.save
      render json: @device
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

    # Only allow a list of trusted parameters through.
    def device_params
      params.require(:device).permit(:device_token)
    end
end
