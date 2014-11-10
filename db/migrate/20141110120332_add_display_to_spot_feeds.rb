class AddDisplayToSpotFeeds < ActiveRecord::Migration
  def change
    add_column :spot_feeds, :display, :boolean
  end
end
