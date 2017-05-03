json.extract! fandom, :id, :name, :profile_img, :background_img, :created_at, :updated_at
json.url fandom_url(fandom, format: :json)
