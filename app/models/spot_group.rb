class SpotGroup < ActiveRecord::Base
  has_many :spot_feeds, dependent: :destroy

  def to_arr_for_json(date: nil)
    spot_feeds.displayable.each_with_index.map do |sf, idx|
      {
        color: SpotFeed::COLORS.reverse[idx],
        messages: sf.to_arr_for_json(date: date),
        name: sf.name,
        display_name: sf.display_name
      }
    end
  end
end
