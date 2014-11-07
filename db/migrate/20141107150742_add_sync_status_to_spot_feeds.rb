class AddSyncStatusToSpotFeeds < ActiveRecord::Migration
  def change
    add_column :spot_feeds, :sync_status, :string
  end
end
