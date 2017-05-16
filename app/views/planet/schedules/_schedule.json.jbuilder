json.extract! schedule, :id, :fandom_id, :category, :title, :content, :event_start, :event_end, :url, :class_name, :created_at, :updated_at
json.url schedule_url(schedule, format: :json)
