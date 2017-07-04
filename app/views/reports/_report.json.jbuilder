json.extract! report, :id, :user_id, :link_id, :wiki_post_id, :history_id, :schedule_id, :fandom_id, :content, :created_at, :updated_at
json.url report_url(report, format: :json)
