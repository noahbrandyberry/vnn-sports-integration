json.extract! team, :id, :name, :label, :photo_url, :home_description, :hide_gender, :year, :season, :level, :program, :created_at, :updated_at
json.url api_v1_school_team_url(team.school_id, team, format: :json)
json.gender team.program.try(:gender) || team.gender
json.sport team.program.try(:sport) || team.sport
json.school_id team.program.try(:school_id) || team.school_id
json.record team.record