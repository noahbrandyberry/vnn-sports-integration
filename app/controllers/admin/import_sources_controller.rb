class Admin::ImportSourcesController < ApplicationController
  before_action :authenticate_admin!
  before_action :require_current_school
  before_action :set_import_source, only: %i[show edit update destroy sync]
  layout "admin"

  # GET /import_sources
  def index
    @import_sources = @current_school.import_sources.where(year: selected_year_id)
  end

  # GET /import_sources/1
  def show
    @events = @import_source.events.includes(:location, :team_events)
  end

  # GET /import_sources/new
  def new
    @import_source = @current_school.import_sources.new
  end

  # GET /import_sources/1/edit
  def edit
    @import_source.preview
  end

  # POST /import_sources
  def create
    @import_source = @current_school.import_sources.new(import_source_params)
    @import_source.year_id = selected_year_id

    respond_to do |format|
      if @import_source.save
        ImportSourceJob.perform_later @import_source
        format.html do
          redirect_to admin_import_source_url(@import_source), notice: "Import source was successfully created."
        end
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /import_sources/1
  def update
    respond_to do |format|
      if @import_source.update(import_source_params)
        ImportSourceJob.perform_later @import_source
        format.html do
          redirect_to admin_import_source_url(@import_source), notice: "Import source was successfully updated."
        end
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /import_sources/1
  def destroy
    @import_source.destroy

    respond_to do |format|
      format.html { redirect_to admin_import_sources_url, notice: "Import source was successfully destroyed." }
    end
  end

  # POST /import_sources/1/sync
  def sync
    ImportSourceJob.perform_later @import_source

    respond_to do |format|
      format.html { redirect_to admin_import_source_url(@import_source), notice: "Sync started." }
    end
  end

  # DELETE /import_sources/1 or /import_sources/1.json
  def preview
    @import_source = @current_school.import_sources.find_by(id: params[:id])
    @import_source ||= @current_school.import_sources.new
    @import_source.assign_attributes(import_source_params)
    @import_source.year_id = selected_year_id
    @import_source.preview

    respond_to do |format|
      if @import_source.persisted?
        format.html { render :edit, status: @import_source.valid? ? :found : :unprocessable_entity }
      else
        format.html { render :new, status: @import_source.valid? ? :found : :unprocessable_entity }
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_import_source
    @import_source = @current_school.import_sources.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def import_source_params
    params.require(:import_source).permit(:name, :url, :sport_id, :gender_id, :level_id, :frequency_hours)
  end
end
