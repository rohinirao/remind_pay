json.extract! reminder, :id, :title, :description, :trigger_at, :price, :currency, :recurrence, :created_at, :updated_at
json.url reminder_url(reminder, format: :json)
