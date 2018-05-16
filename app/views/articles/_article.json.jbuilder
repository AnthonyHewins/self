json.extract! article, :id, :title, :body, :tldr, :author, :created_at, :updated_at
json.url article_url(article, format: :json)
