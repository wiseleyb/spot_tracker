class CreateSpotGroups < ActiveRecord::Migration
  def change
    create_table :spot_groups do |t|
      t.string :name
      t.timestamps
    end

    add_column :spot_feeds, :spot_group_id, :integer

    SpotFeed.reset_column_information
    sg = SpotGroup.create(name: 'Spots')
    SpotFeed.update_all(spot_group_id: sg.id)
  end
end
