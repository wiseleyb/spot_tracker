FactoryGirl.define do
  factory :spot_feed do
    spot_group_id ""
    feed_id ""
    name ""
    display_name ""
    description ""
    status ""
    usage ""
    days_range ""
    detailed_message_shown false
    sync false
    sync_state ""
  end
end
