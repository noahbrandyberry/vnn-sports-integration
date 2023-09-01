class Admin::SchoolsController < ApplicationController
  before_action :authenticate_admin!
  before_action :require_current_school, only: %i[ show edit update destroy ]
  before_action :set_school, only: %i[ show edit update destroy ]
  before_action :unset_school, only: %i[ index new create ]
  layout 'admin'

  # GET /schools or /schools.json
  def index
    @schools = current_admin.schools.includes(:teams, :location)

    respond_to do |format|
      format.html
      format.json { render json: @schools }
    end

  end

  # GET /schools/1 or /schools/1.json
  def show
    session[:school_id] = params[:id]
    set_current_school
    set_school
  end

  # GET /schools/new
  def new
    @school = current_admin.schools.new
    @school.location = Location.new
  end

  # GET /schools/1/edit
  def edit
  end

  # POST /schools or /schools.json
  def create
    @school = School.new(school_params)
    @school.admins = [current_admin]
    @school.location.name = @school.name
    @school.location.store_metadata

    respond_to do |format|
      if @school.save
        format.html { redirect_to admin_school_url(@school), notice: "School was successfully created." }
        format.json { render :show, status: :created, location: @school }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @school.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /schools/1 or /schools/1.json
  def update
    @school.assign_attributes(school_params)
    @school.location.name = @school.name
    @school.location.store_metadata

    respond_to do |format|
      if @school.save
        format.html { redirect_to admin_school_url(@school), notice: "School was successfully updated." }
        format.json { render :show, status: :ok, location: @school }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @school.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /schools/1 or /schools/1.json
  def destroy
    @school.destroy

    respond_to do |format|
      format.html { redirect_to admin_schools_url, notice: "School was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_school
      @school = @current_school
    end

    # Only allow a list of trusted parameters through.
    def school_params
      params.require(:school).permit(:name, :mascot, :url, :logo_url, :primary_color, :athletic_director, :phone, :email, :instagram_url, :twitter_url, :facebook_url, location_attributes: [:id, :address_1, :address_2, :city, :state, :zip, :plus_4, :_destroy])
    end
end
