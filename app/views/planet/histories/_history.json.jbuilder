json.extract! history, :id, :fandom_id, :user_id, :title, :event_date, :created_at, :updated_at
json.url history_url(history, format: :json)
