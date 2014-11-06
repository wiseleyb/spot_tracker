class CreateSpotFeeds < ActiveRecord::Migration
  def change
    create_table :spot_feeds do |t|
      t.string  :feed_id
      t.string  :name
      t.string  :description
      t.string  :status
      t.integer :usage
      t.integer :days_range
      t.boolean :detailed_message_shown

      t.timestamps
    end
    add_index :spot_feeds, :feed_id, unique: true
  end
end
