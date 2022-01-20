class Api::V1::SchoolsController < ApplicationController
  before_action :set_school, only: %i[ show update destroy ]

  # GET /schools
  # GET /schools.json
  def index
    @schools = School.all
  end

  # GET /schools/1
  # GET /schools/1.json
  def show
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_school
      @school = School.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def school_params
      params.require(:school).permit(:name, :mascot, :is_vnn, :url, :logo_url, :anti_discrimination_disclaimer, :registration_text, :registration_url, :primary_color, :secondary_color, :tertiary_color, :enrollment, :athletic_director, :phone, :email, :blog, :sportshub_version, :version, :instagram, :onboarding)
    end
end
