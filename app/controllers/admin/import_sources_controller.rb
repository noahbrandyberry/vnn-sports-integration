class Admin::ImportSourcesController < ApplicationController
  before_action :authenticate_admin!
  before_action :require_current_school
  before_action :set_import_source, only: %i[ show edit update destroy ]
  layout 'admin'

  # GET /import_sources or /import_sources.json
  def index
    @import_sources = @current_school.import_sources
  end

  # GET /import_sources/1 or /import_sources/1.json
  def show
  end

  # GET /import_sources/new
  def new
    @import_source = @current_school.import_sources.new
  end

  # GET /import_sources/1/edit
  def edit
  end

  # POST /import_sources or /import_sources.json
  def create
    @import_source = @current_school.import_sources.new(import_source_params)

    respond_to do |format|
      if @import_source.save
        ImportSourceJob.perform_later @import_source
        format.html { redirect_to admin_import_source_url(@import_source), notice: "Import source was successfully created." }
        format.json { render :show, status: :created, location: @import_source }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @import_source.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /import_sources/1 or /import_sources/1.json
  def update
    respond_to do |format|
      if @import_source.update(import_source_params)
        ImportSourceJob.perform_later @import_source
        format.html { redirect_to admin_import_source_url(@import_source), notice: "Import source was successfully updated." }
        format.json { render :show, status: :ok, location: @import_source }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @import_source.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /import_sources/1 or /import_sources/1.json
  def destroy
    @import_source.destroy

    respond_to do |format|
      format.html { redirect_to admin_import_sources_url, notice: "Import source was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  # DELETE /import_sources/1 or /import_sources/1.json
  def preview
    @import_source = @current_school.import_sources.find_by(id: params[:id])
    @import_source = @current_school.import_sources.new unless @import_source
    @import_source.assign_attributes(import_source_params)
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
