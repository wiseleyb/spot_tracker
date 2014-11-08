class SpotMessage < ActiveRecord::Base
  belongs_to :spot_feed

  scope :mappable, -> { where.not(message_type: ['POWER-OFF', 'HELP-CANCEL']) }
end
