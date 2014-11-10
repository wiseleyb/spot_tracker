json.array!(@spot_feeds) do |spot_feed|
  json.extract! spot_feed, :id, :feed_id, :name, :description, :status,
    :usage, :days_range, :detailed_message_shown, :sync, :sync_status,
    :spot_group_id, :display, :display_name
  json.url spot_feed_url(spot_feed, format: :json)
end
