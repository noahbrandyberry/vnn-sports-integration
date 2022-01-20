json.extract! team, :id, :name, :label, :photo_url, :home_description, :hide_gender, :school, :created_at, :updated_at
json.url api_v1_school_team_url(team.school_id, team, format: :json)
