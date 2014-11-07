class CreateSpotMessages < ActiveRecord::Migration
  def change
    create_table :spot_messages do |t|
      t.integer   :spot_feed_id
      t.integer   :spot_id
      t.string    :messenger_id
      t.string    :messenger_name
      t.integer   :unix_time
      t.string    :message_type
      t.float     :latitude
      t.float     :longitude
      t.string    :model_id
      t.string    :show_custom_msg
      t.datetime  :date_time
      t.integer   :hidden
      t.string    :message_content

      t.timestamps
    end
    add_index :spot_messages, :spot_id, unique: true
    add_index :spot_messages, :spot_feed_id
  end
end
