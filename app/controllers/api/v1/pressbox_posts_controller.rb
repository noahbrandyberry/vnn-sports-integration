class Api::V1::PressboxPostsController < ApplicationController
  protect_from_forgery with: :null_session
  before_action :set_school
  before_action :set_team
  before_action :set_pressbox_post, only: %i[ show ]

  # GET /pressbox_posts
  # GET /pressbox_posts.json
  def index
    @pressbox_posts = @team.pressbox_posts
  end

  # GET /pressbox_posts/1
  # GET /pressbox_posts/1.json
  def show
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pressbox_post
      @pressbox_post = @team.pressbox_posts.find(params[:id])
    end

    def set_team
      @team = @school.teams.find(params[:team_id])
    end

    def set_school
      @school = School.find(params[:school_id])
    end

    # Only allow a list of trusted parameters through.
    def pressbox_post_params
      params.require(:pressbox_post).permit(:is_visible, :created, :modified, :created_by, :modified_by, :submitted, :submitted_by, :title, :recap, :boxscore, :website_only, :featured_image)
    end
end
