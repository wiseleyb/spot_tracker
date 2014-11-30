class SpotGroup < ActiveRecord::Base
  has_many :spot_feeds, dependent: :destroy

  def to_arr_for_json(date: nil, days: 1, feed_id: nil)
    # get rid of blanks passed in from params
    date = nil if date.blank?
    days = nil if days.blank?
    feed_id = nil if feed_id.blank?

    feeds = spot_feeds.displayable
    if feed_id
      feeds = feeds.where(id: feed_id)
    end

    # TODO: This is n+1 query... lame - fix
    feeds.each_with_index.map do |sf, idx|
      {
        color: SpotFeed::COLORS.reverse[idx],
        messages: sf.to_arr_for_json(date: date, days: days),
        name: sf.name,
        display_name: sf.display_name
      }
    end
  end

  def message_dates
    spot_feeds
      .includes(:spot_messages)
      .displayable
      .map(&:spot_messages)
      .flatten
      .map {|m| m.date_time.to_date.to_s(:db)}
      .uniq
      .sort
      .reverse
  end
end
