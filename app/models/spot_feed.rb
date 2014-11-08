class SpotFeed < ActiveRecord::Base
  has_many :spot_messages, dependent: :destroy

  scope :syncable, -> {
    where(sync: true).where('updated_at < ? OR created_at = updated_at',
                            5.minutes.ago)
  }

  def feed_url
    'https://api.findmespot.com/spot-main-web/consumer/rest-api/2.0/' +
    "public/feed/#{feed_id}/message.xml"
  end

  def to_json
    spot_messages.mappable.map do |m|
      {
        lat: m.latitude,
        lng: m.longitude,
        title: "#{m.message_type}: #{m.date_time}"
      }
    end.to_json.html_safe
  end

  def test_large_json
    res = []
    1000.times do
      res << {lat: range(24, 49), lng: range(-124, -66)}
    end
    res.to_json.html_safe
  end

  def range (min, max)
    rand * (max-min) + min
  end
end
