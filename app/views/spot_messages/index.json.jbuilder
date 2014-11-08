json.array!(@spot_messages) do |spot_message|
  json.extract! spot_message, :id, :spot_feed_id, :spot_id, :messenger_id,
    :messenger_name, :unix_time, :message_type, :latitude, :longitude,
    :model_id, :show_custom_msg, :date_time, :battery_state, :hidden, :message_content
  json.url spot_message_url(spot_message, format: :json)
end
