json.extract! school, :id, :name, :mascot, :is_vnn, :url, :logo_url, :anti_discrimination_disclaimer, :registration_text, :registration_url, :primary_color, :secondary_color, :tertiary_color, :enrollment, :athletic_director, :phone, :email, :blog, :sportshub_version, :version, :instagram, :onboarding, :location, :visible, :created_at, :updated_at
json.url api_v1_school_url(school, format: :json)
