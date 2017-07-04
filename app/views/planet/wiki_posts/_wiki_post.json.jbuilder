json.extract! wiki_post, :id, :user_id, :wiki_id, :title, :content, :commit_msg, :row_count, :url, :created_at, :updated_at
json.url wiki_post_url(wiki_post, format: :json)
