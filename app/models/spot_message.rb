class SpotMessage < ActiveRecord::Base
  belongs_to :spot_feed

  BAD_COORDINATES     = [-99999.0]
  BAD_MESSAGE_TYPES   = ['POWER-OFF', 'HELP-CANCEL']

  scope :mappable, -> {
    where.not(message_type: BAD_MESSAGE_TYPES,
              latitude:     BAD_COORDINATES,
              longitude:    BAD_COORDINATES)
  }
end
