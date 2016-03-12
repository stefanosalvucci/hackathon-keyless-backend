json.array!(@events) do |event|
  json.extract! event, :id, :status, :requester
  json.url event_url(event, format: :json)
end
