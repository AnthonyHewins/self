json.extract! project, :id, :name, :description, :url, :image, :created_at, :updated_at
json.url project_url(project, format: :json)
