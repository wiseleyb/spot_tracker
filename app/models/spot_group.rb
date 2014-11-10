class SpotGroup < ActiveRecord::Base
  has_many :spot_feeds, dependent: :destroy

  def to_arr_for_json
    spot_feeds.displayable.each_with_index.map do |sf, idx|
      {
        color: SpotFeed::COLORS.reverse[idx],
        messages: sf.to_arr_for_json,
        name: sf.name
      }
    end
  end
end
