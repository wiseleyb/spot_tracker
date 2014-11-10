class AddDisplayNameToSpotFeeds < ActiveRecord::Migration
  def change
    add_column :spot_feeds, :display_name, :string
  end
end
