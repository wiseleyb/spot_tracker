class SpotFeed < ActiveRecord::Base
  belongs_to :spot_group, touch: true
  has_many :spot_messages, dependent: :destroy

  scope :syncable, -> {
    where(sync: true).where('updated_at < ? OR created_at = updated_at',
                            5.minutes.ago)
  }
  scope :displayable, -> { where(display: true) }

  alias_method :messages, :spot_messages

  # Color sets
  # http://colorbrewer2.org/
  # http://www.colourlovers.com/palettes/most-loved/all-time/meta
  COLORS = %w(67001f b2182b d6604d f4a582 fddbc7 f7f7f7
              d1e5f0 92c5de 4393c3 2166ac)

  def feed_url
    'https://api.findmespot.com/spot-main-web/consumer/rest-api/2.0/' +
    "public/feed/#{feed_id}/message.xml"
  end

  def to_arr_for_json(date: nil, feed_id: nil)
    json = []
    messages = spot_messages.mappable

    if date
      messages = messages.by_date(date)
    end

    if feed_id
      messages = messages.by_feed(feed_id)
    end

    messages.each_with_index do |m, idx|
      h = {
        lat: m.latitude,
        lng: m.longitude,
        title: "#{self.display_name}: #{m.date_time}",
        line_info: '',
      }

      if idx > 0
        arr = []
        m1 = messages[idx - 1]
        arr << self.display_name
        arr << "Distance: #{m1.distance_to(m).round(2)} miles"
        arr << "Speed: #{m1.speed_to(m).round(2)} mph"
        arr << "Time: #{(m1.seconds_to(m)/60).round(2)} minutes"
        arr << "Heading: #{m1.compass_point_to(m)} #{m1.heading_to(m).to_i}"
        arr << "On: #{m1.date_time.to_s(:short)}"
        h[:line_info] = arr.join('<br/>')
      end

      json << h
    end
    json #.to_json.html_safe
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
