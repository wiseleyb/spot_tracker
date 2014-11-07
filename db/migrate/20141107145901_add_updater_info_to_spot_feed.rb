class AddUpdaterInfoToSpotFeed < ActiveRecord::Migration
  def change
    add_column :spot_feeds, :sync, :boolean
  end
end
