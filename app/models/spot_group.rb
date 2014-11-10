class SpotGroup < ActiveRecord::Base
  has_many :spot_feeds, dependent: :destroy

  def to_arr_for_json
    spot_feeds.displayable.map(&:to_arr_for_json).
      each_with_index.map do |sf, idx|
      {
        color: SpotFeed::COLORS.reverse[idx],
        messages: sf
      }
    end
  end
end
