class AddBatteryStateToSpotMessages < ActiveRecord::Migration
  def change
    add_column :spot_messages, :battery_state, :string
  end
end
