json.array!(@spot_feeds) do |spot_feed|
  json.extract! spot_feed, :id, :feed_id, :name, :description, :status, :usage, :days_range, :detailed_message_show
  json.url spot_feed_url(spot_feed, format: :json)
end