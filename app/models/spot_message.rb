class SpotMessage < ActiveRecord::Base
  belongs_to :spot_feed, touch: true

  BAD_COORDINATES     = [-99999.0]
  BAD_MESSAGE_TYPES   = ['POWER-OFF', 'HELP-CANCEL']

  default_scope { order('date_time ASC') }

  scope :mappable, -> {
    where.not(message_type: BAD_MESSAGE_TYPES,
              latitude:     BAD_COORDINATES,
              longitude:    BAD_COORDINATES)
  }

  alias_attribute :lat, :latitude
  alias_attribute :lng, :longitude

  def distance_to(spot_message)
    Geokit::LatLng.distance_between(self.lat_lng, spot_message.lat_lng)
  end

  def heading_to(spot_message)
    Geokit::LatLng.heading_between(self.lat_lng, spot_message.lat_lng)
  end

  def compass_point_to(spot_message)
    Geocoder::Calculations.compass_point(self.heading_to(spot_message))
  end

  def lat_lng
    Geokit::LatLng.new(self.lat, self.lng)
  end

  def speed_to(spot_message)
    self.distance_to(spot_message) / self.hours_to(spot_message)
  end

  def seconds_to(spot_message)
    (self.date_time - spot_message.date_time).abs
  end

  def hours_to(spot_message)
    self.seconds_to(spot_message) / 60 / 60
  end
end
